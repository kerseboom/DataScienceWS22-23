# install.packages("osmdata", "archive)
library(tidyverse)
library(sf)
library(osmdata)
library(tmap)
library(readxl)
library(archive)

tmap_mode("view")


##### PART 1: Demographic Data 

# download PLR data
# for descriptions of variables, see https://www.stadtentwicklung.berlin.de/planen/basisdaten_stadtentwicklung/monitoring/de/2021/daten_zum_bericht_2021.shtml
download.file(url = "https://www.stadtentwicklung.berlin.de/planen/basisdaten_stadtentwicklung/monitoring/download/2021/tabellen/daten_2016-2018/excel/Tabelle_2-1-1_KI_Daten_2016_PLR_MSS_2021.xlsx",
              destfile = "plr_data.xlsx",
              mode = "wb")

# load PLR data
plr_data <- read_excel("plr_data.xlsx", skip = 5)

# clean PLR data
plr_data2 <- plr_data[-(1:2),] %>% select(Planungsraum, plr_name = '...2', pop = EW, pct_longterm = 'K 10 -neu-' )


# download berlin plr shape file
download.file(url = "https://www.stadtentwicklung.berlin.de/planen/basisdaten_stadtentwicklung/lor/download/LOR_SHP_2021.7z",
              destfile = "plr_shp.7z",
              mode = "wb")

# unzip plr_shp
archive_extract("plr_shp.7z")

# read shape file
plr_shp <- st_read("lor_plr.shp")

# join shape file with data 
plr_joined <- plr_shp %>% 
  left_join(plr_data2, by = c("PLR_ID" = "Planungsraum")) %>% 
  mutate(pop = as.numeric(pop), pct_longterm = as.numeric(pct_longterm))


# map population per PLR
tm_shape(plr_joined) + 
  tm_polygons(col = "pop", id = "PLR_NAME")

# map percent of people who have lived in the same place more than 5 years

tm_shape(plr_joined) + 
  tm_polygons(col = "pct_longterm", id = "PLR_NAME")

##### PART 2: Open Street Map Data

# see all features that you can query
available_features()

available_tags("shop")

# Pull and plot all doctors' offices
amenity <- opq(bbox = 'Berlin, Germany')  %>%
  add_osm_feature(key = "amenity", value = "doctors") %>% 
  osmdata_sf()


tm_shape(amenity$osm_points)+
  tm_dots()

# Grab and plot all doctors' offices AND hospitals
amenity <- opq(bbox = 'Berlin, Germany')  %>%
  add_osm_feature(key = "amenity", value = c("doctors", "hospital")) %>% 
  osmdata_sf()

tm_shape(amenity$osm_points)+
  tm_dots(col = "amenity", id = "name")

# Now plot the polygons
tm_shape(amenity$osm_polygons)+
  tm_fill(col = "amenity", id = "name")

# Combine points & polygons
## Attempt 1: plot points and polygons on same map
tm_shape(amenity$osm_points)+
  tm_dots(col = "amenity", id = "name") +
  tm_shape(amenity$osm_polygons)+
  tm_fill(col = "amenity", id = "name")

## Attempt 2: turn polygons into points & then plot both
polygons_as_points <- amenity$osm_polygons %>% st_centroid() %>% select(name,amenity)
points <- amenity$osm_points %>% 
  select(name,amenity) %>% 
  filter(!is.na(name))
combined <- rbind(points, polygons_as_points)

tm_shape(combined)+
  tm_dots(col = "amenity", id = "name")


# Exercises:
# 1) Scroll through the map features from wiki; choose one that interests you. 
# Follow steps above to create a map containing all instances of this feature. 
# https://wiki.openstreetmap.org/wiki/Map_features
# hint: to save computation resources / time, choose a feature that there
# aren't too many of in Berlin.



# 2) Load berlin districts shape file into R & plot districts on same map as amenities
download.file(url = "https://tsb-opendata.s3.eu-central-1.amazonaws.com/bezirksgrenzen/bezirksgrenzen.shp.zip",
              destfile = "berlin_districts.zip",
              mode = "wb")

unzip("berlin_districts.zip", exdir = "berlin_districts")

districts <- st_read("berlin_districts/bezirksgrenzen.shp")





# 3) Remove all features that are located outside of Berlin.
# Plot features within Berlin. 
# hint: st_intersection may help




# 4) Calculate number of features in each district ("Bezirk"). Plot results.
# hint: st_join could be helpful



# 5) Calculate number of features per Planungsraum (see Part 1 of this code).



# 6) Using the population column of the the Planungsraum dataset, calculate how many residents
# have to share one feature per Planungsraum (supermarket, cinema, doctors office, etc...)


