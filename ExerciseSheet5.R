library(tidyverse)
library(nycflights13)


# Slide 6 -----------------------------------------------------------------
flights

# Slide 7 -----------------------------------------------------------------
planes
flights_planes <- left_join(flights, planes)

weather 
flights_weather <- left_join(flights, select(weather, c(origin, year, month, day, hour, time_hour, temp)))

airlines
flights_airlines <- left_join(flights,airlines)

airports
flights_origin_airport_data <- left_join(flights, airports, by = c("origin" = "faa")) 
flights_dest_airport_data <- right_join(airports, flights, by = c("faa" = "dest")) 

# Slide 14 -----------------------------------------------------------------

x <- 'hello'
y <- "goodbye"

# Slide 15 -----------------------------------------------------------------
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

str_sub(x, -3, -1)

str_replace(x, "Apple", "Kiwi")

# Slide 16 -----------------------------------------------------------------
y <- str_to_upper(x)
x <- str_to_lower(y)
x <-c("apple", "eggplant", "banana")
str_sort(x, locale = "en")

# Slide 17 -----------------------------------------------------------------
x <- c("apple", "banana", "pear")



#task1####
airports <- airports
flights <- flights

delay_per_airport <- flights %>% 
  group_by(dest) %>% 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  ungroup()

airports_new <- airports %>% right_join(delay_per_airport, c("faa" = "dest"))

airports_new %>% 
  semi_join(flights , c("faa" = "dest")) %>%
  ggplot(mapping = aes(x = lon, y = lat, color = avg_delay)) +
  borders("state") + geom_point () + coord_quickmap ()

#task2####
airport_location <- airports %>% 
  select(c("faa", "lon", "lat"))

flights2 <- flights %>% 
  left_join(airport_location, c("dest" = "faa"))


#task3####
planes <- planes


delay_per_plane<- flights %>% 
  group_by(tailnum) %>% 
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  ungroup()


planes3 <- planes %>% left_join(delay_per_plane, "tailnum")
  
plot(planes3$year, planes3$avg_delay
     )
  


