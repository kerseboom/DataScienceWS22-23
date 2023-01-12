library(sf)
library(tmap)
library(tidytransit)
library(tidyverse)


# Download & unzip input files. (The following code chunk only needs to be performed once)
download.file(url = "https://tsb-opendata.s3.eu-central-1.amazonaws.com/bezirksgrenzen/bezirksgrenzen.shp.zip",
             destfile = "berlin_districts.zip",
             mode = "wb")

unzip("berlin_districts.zip", exdir = "berlin_districts")

download.file(url = "vbb.de/vbbgtfs",
              destfile = "berlin_gtfs.zip",
              mode = "wb")

# use sf's "st_read()" to read in Berlin's districts
districts <- st_read("berlin_districts/bezirksgrenzen.shp")

tmap_mode("view")
tm_shape(districts) + 
  tm_polygons()

# use tidytransit's "read_gtfs()" to read in entire GTFS feed for VBB area 
berlin_gtfs <- read_gtfs("berlin_gtfs.zip")

# Filter entire GTFS feed to only include relevant info for given day and time-range:
# today (Jan 9) between 17:00 and 18:00. 
gtfs_filtered <- berlin_gtfs %>%
  filter_feed_by_date("2023-01-09", "06:30:00","10:00:00")

# use tidytransit's "gtfs_as_sf()" to convert each transit stops into a st_point and
# each trip into a st_linestring 
gtfs_filtered <- gtfs_as_sf(gtfs_filtered)

# In the next steps we are going to filter the various datasets to only include
# scheduling information relevant to the sbahn

# A) Find agency id for sbahn
view(gtfs_filtered$agency) # agency_id of sbahn is 1

# B) Filter routes to only include sbahn
routes <- gtfs_filtered$routes
routes_sbahn <- routes %>% filter(agency_id == 1)
route_ids_sbahn <- routes_sbahn$route_id

# C) Filter trips to only include sbahn (use route_ids_sbahn)
trips <- gtfs_filtered$trips
trips_sbahn <- trips %>% filter(route_id %in% route_ids_sbahn)
trip_ids_sbahn <- trips_sbahn$trip_id

trips_sbahn_sf <- get_trip_geometry(gtfs_filtered, trip_ids_sbahn)
tm_shape(trips_sbahn_sf) + 
  tm_lines(col = "darkgreen", alpha = 0.02)

# D) Filter stop_times to only include sbahn (use trip_ids_sbahn)
stop_times <- gtfs_filtered$stop_times 
stop_times_sbahn <- stop_times %>% filter(trip_id %in% trip_ids_sbahn)
stop_ids_sbahn <- unique(stop_times_sbahn$stop_id)

# E) Filter stops to only include those relevant to sbahn
stops <- gtfs_filtered$stops
stops_sbahn <- stops %>% filter(stop_id %in% stop_ids_sbahn)

tm_shape(stops_sbahn) + 
  tm_dots()


tm_shape(districts) + 
  tm_borders(col = "blue") +
  tm_shape(trips_sbahn_sf) + 
  tm_lines(col = "darkgreen") + 
  tm_shape(stops_sbahn) + 
  tm_dots(id = "stop_name") 

# Count departures per sbahn stop. 
departures_per_stop <- stop_times_sbahn %>% 
  group_by(stop_id) %>%
  count()

# Join with stops_sbahn
stops_sbahn_deps <- stops_sbahn %>%
  left_join(departures_per_stop)

tm_shape(stops_sbahn_deps) + 
  tm_dots(size = "n", col = "n", id = "stop_name")

# to solve the problem of multiple stops being in the same location, you could do the following: 
stops_sbahn_deps <- stops_sbahn %>%
  left_join(departures_per_stop) %>% 
  cluster_stops(max_dist = 300, group_col = "stop_name", cluster_colname = "stop_name") %>%
  group_by(stop_name) %>% 
  summarise(n = sum(n)) %>% st_centroid()

tm_shape(stops_sbahn_deps) + 
  tm_dots(size = "n", col = "n", id = "stop_name")


# Exercises
# 1) Join "stops_sbahn_deps" sf to "district" sf; calculate how many sbahn departures occur in each district in the AM peak
# Bonus: Now calculate concentration of sbahn departures per district (# of sbahn departures in district / area of district) and show on map
task1 <- st_join(stops_sbahn_deps, districts) 
result1 <- task1 %>% group_by(Gemeinde_n) %>% 
  select(Gemeinde_n, n) %>%
  na.omit(Gemeinde_n) %>% 
  st_drop_geometry()
  
#BONUS IS MISSING!

# 2) Play with the color aesthetics of previous map. 
# a) only have three color bins
# b) set manual breaks, e.g. 0 -> 200, 201 -> 1000, 10001 -> 1099, 1100 -> inf



# 3) Plot the area of Berlin that is within 1.5km of an sbahn station
# Hint: use st_buffer()
# Hint2: st_intersection & st_union may be useful to get a cleaner results

