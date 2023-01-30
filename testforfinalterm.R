library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(readxl)
library(archive)
library(matsim)


berlin_10pct_output_trips <-  readTripsTable("~/Downloads/berlin-v5.5.3-10pct.output_trips.csv.gz") 

districts <- st_read("data/berlin_districts/bezirksgrenzen.shp")


trips <- berlin_10pct_output_trips %>%  select(dep_time, trav_time, wait_time, traveled_distance, main_mode, start_activity_type, end_activity_type, start_x, start_y, end_x, end_y)
test <- trips[1:100,]




#build a sf df with the coords
start_sf <- st_as_sf(test, coords = c("start_x", "start_y"), crs = 31468)

# Join the simple feature object with the district shapefile
start_sf <- st_join(start_sf, districts)

# Add the district id to the dataframe
test$start_district_name <- start_sf$Gemeinde_n

# Repeat the process for end point
end_sf <- st_as_sf(test, coords = c("end_x", "end_y"), crs = st_crs(districts))
end_sf <- st_join(end_sf, districts)
df$end_district_name <- end_sf$Gemeinde_n





tmap_mode("view")
tm_shape(start_sf)+
  tm_dots()+
  tm_shape(districts)+
  tm_polygons(id="Gemeinde_n", alpha = 0.5)