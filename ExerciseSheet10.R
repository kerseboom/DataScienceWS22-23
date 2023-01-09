library(tidyverse)
library(sf)
library(spData)
library(tmap)

# SIMPLE FEATURE GEOMETRY (SFG)

# create matrix; each row is one coordinate pair (in vector form)
coords_left <- rbind(c(0,0), c(1,1), c(1,0), c(0,0))

# multipoint
multipoint_left <- st_multipoint(coords_left)
plot(multipoint_left, col = "blue") # two points at (0.0) overlap; thus only three points visible

# linestring  
linestring_left <- st_linestring(coords_left)
plot(linestring_left, col = "blue")

# polygon
# Note: coordinate matrix must be within a list
polygon_left <- st_polygon(list(coords_left))
plot(polygon_left, col = "blue")
class(polygon_left)

# casting: convert btwn points, lines, and polygons
plot(multipoint_left, col = "blue") # multipoint
plot(st_cast(multipoint_left, "LINESTRING"), col = "blue") # multipoint -> linestring
plot(st_cast(multipoint_left, "POLYGON"), col = "blue") # linestring -> polygon

# topological relations
# create another triangle
coords_right = rbind(c(1,0), c(1,1), c(2,0), c(1,0))
polygon_right <- st_polygon(list(coords_right))

# now create a square within left triangle
coords_square = rbind(c(0.5, 0), c(0.5,0.25), c(0.75, 0.25), c(0.75, 0), c(0.5,0))
polygon_square <- st_polygon(list(coords_square))

plot(polygon_left, col = "blue")
plot(polygon_right, col = "red", add = TRUE) # Note: add=TRUE -> previous plot is not erased
plot(polygon_square, col = "yellow", add = TRUE)

# compare left and right triangle
# Note: "sparse = FALSE" is used to return TRUE/FALSE instead of 0/1
st_intersects(polygon_left, polygon_right, sparse = FALSE)[, 1] # TRUE
st_touches(polygon_left, polygon_right, sparse = FALSE)[, 1] # TRUE
st_overlaps(polygon_left, polygon_right, sparse = FALSE)[, 1] # FALSE
st_contains(polygon_left, polygon_right, sparse = FALSE)[, 1] # FALSE

# compare left triangle and yellow square
st_intersects(polygon_left, polygon_square, sparse = FALSE)[, 1] # TRUE
st_touches(polygon_left, polygon_square, sparse = FALSE)[, 1] # FALSE - interior of polygons may not share space
st_overlaps(polygon_left, polygon_square, sparse = FALSE)[, 1] # FALSE - cannot be completely contained 
st_contains(polygon_left, polygon_square, sparse = FALSE)[, 1] # TRUE 

# compare right triangle and yellow square
st_disjoint(polygon_right, polygon_square, sparse = FALSE)[, 1] # TRUE

# some miscellaneous operations:
# union
union_left_right <- st_union(polygon_left, polygon_right)
plot(union_left_right, col = "purple")

# intersection
intersection_left_square <- st_intersection(polygon_left, polygon_square)
plot(intersection_left_square, col = "yellow")

# difference 
diff_left_square <- st_difference(polygon_left, polygon_square)
plot(diff_left_square, col = "blue")

# SIMPLE FEATURE COLUMN (sfc)
# Note: usually, you would put a crs in the following function; 
# it is ommitted here because we're just looking at shapes
polygon_sfc <- st_sfc(list(polygon_left,polygon_right, polygon_square))
plot(polygon_sfc)
class(polygon_sfc)

# ATTRIBUTES
attrib <- data.frame(name = c("left triangle", "right triangle", "square"),
                     shape = c("triangle", "triangle","square"))
class(attrib)

# SIMPLE FEATURE
polygon_sf <- st_sf(attrib, geometry = polygon_sfc)
plot(polygon_sf)


# Exercises:
# 1) Cast polygon_square (defined above) to lines, and points



# 2) Find centroid of polygon_left. Plot both polygon_left and centroid_left
# Note: Use sf cheat sheet to find correct function: https://osf.io/an6b5/download
# Hint: remember to use option "add=TRUE" within plot if you want to overlay multiple plots
pol_left_centroid <- st_centroid(polygon_left)
task1.2 <- st_sfc(list(polygon_left, pol_left_centroid))
plot(task1.2, add=T)


# 3) Make a buffer polygon around polygon_left; Plot both polygon_left and polygon_left_buffer
pol_left_buffer <- st_buffer(polygon_left, dist = 5)
task1.3 <- st_sfc(list(pol_left_buffer, polygon_left))
plot(task1.3, add=T)



# TMAP INTRO
# Simple feature containing all 16 states of New Zealand + demographic info
view(nz)
class(nz)
summary(nz)

# Simple feature containing the 101 tallest mountain peaks in New Zealand
view(nz_height)
class(nz_height)
summary(nz_height)

# normal sf "plot"
plot(nz)

# versus tmap
tmap_mode("view") # try using "plot" instead of "view"
tm_shape(nz) + 
  tm_polygons() # try using tm_fill or tm_borders instead

# add some color
tm_shape(nz) + 
  tm_polygons(col = "Median_income")

# layer two simple features over one another
tm_shape(nz) + # nz states
  tm_polygons() + 
  tm_shape(nz_height) + # peaks of 101 tallest mountains
  tm_dots(alpha = 0.2) # a lower alpha makes dots somewhat translucent, so that we can see when multiple peaks are very close to one another 

# WRANGLING SIMPLE FEATURES
# A) by attributes (works the same as with dataframes)
# mutate
nz_mod <- nz %>% mutate(pop_density = Population / Land_area)
tm_shape(nz_mod) +
  tm_polygons(col = "pop_density")

# filter
nz_north <- nz %>% filter(Island == "North")
tm_shape(nz_north) +
  tm_polygons()

# group_by & summarise
nz_agg <- nz %>%
  group_by(Island) %>% 
  summarise(tot_pop = sum(Population))


tm_shape(nz_agg) +
  tm_polygons(col = "tot_pop")

# B) wrangling using geometries
# spatial filter
canterbury <- nz %>% filter(Name == "Canterbury")
canterbury

nz_height_canterbury <- nz_height %>% 
  st_filter(canterbury, .predicate = st_intersects)

tm_shape(nz) + 
  tm_polygons() + 
  tm_shape(nz_height) + # all peaks
  tm_dots() + 
  tm_shape(nz_height_canterbury) + # canterbury peaks in red
  tm_dots(col = "red")

# joins
nz_join <- nz %>% st_join(nz_height) # by default it is a left join

tm_shape(nz_join) + 
  tm_polygons()

nz_join_inner <- nz %>% st_join(nz_height, left = FALSE) # "left = FALSE" leads to inner join

tm_shape(nz_join_inner) + 
  tm_polygons()

# aggregation
nz_avg_elev <- nz_join %>% 
  group_by(Name) %>% 
  summarize(elevation = mean(elevation, na.rm = TRUE))

tm_shape(nz_avg_elev) +
  tm_polygons(col = "elevation")


# Exercises:
# 1) examine "world" dataset (from spData library) using view() and summary().
# Use tmap to plot world map
tmap_mode("view")+
  tm_shape(world)+
  tm_polygons()



# 2) calculate population_density of each country. Colorize map to show pop_density
task2.2 <- world %>% 
  mutate(pop_dens = pop / area_km2)

tmap_mode("view")+
  tm_shape(task2.2)+
  tm_polygons(col = "pop_dens")



# 3) show same map as in two, but only show southern + eastern Asia

task2.3 <- task2.2 %>% 
  filter(subregion == "Southern Asia" | subregion == "Eastern Asia")

tm_shape(task2.3)+
  tm_polygons(col = "pop_dens")
  
# 4) look at the summary of "urban_agglomerations" simple feature (part of spData)
# plot cities from "urban_agglomerations" on top of the "world" map
tm_shape(world)+
  tm_polygons()+
  tm_shape(urban_agglomerations)+
  tm_dots()



# 5) join "urban_agglomerations" and "world" in order to calculate what percentage of
# a country's entire population lives the MOST populated city of that country
# Only use the 2020 values for a city's population.
# Note: urban_agglomerations only contains data for 30 cities 
# so there won't be data for every country
