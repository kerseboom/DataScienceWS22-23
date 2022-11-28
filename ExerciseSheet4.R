library(tidyverse)

### tidyr

## tidy data
table1 # tidy
table2 # not tidy: observations are spread over two rows. 
table3 # not tidy: rate column contains two variables: cases & population
table4a # displays cases, not tidy because column names (1999, 2000) are not variables names but values...
table4b # displays population, not tidy because column names (1999, 2000) are not variables names but values...

## pivot_longer()
table4a

table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

#left_join(tidy4a, tidy4b)

## pivot_wider()
table2
table2 %>%
  pivot_wider(names_from = type, values_from = count)

## separate()

table3

table3 %>% 
  separate(rate, into = c("cases", "population"))

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/") # explicitly defining seperation character

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE) # tell it to convert datatypes.


table3 %>% 
  separate(year, into = c("century", "year"), sep = 2) # using character position to separate


## unite
table5

table5 %>% 
  unite(new, century, year) #  default separator is "_"


table5 %>% 
  unite(new, century, year, sep = "") 

## case study:



### readr

# Download & unzip Data4 from isis. 

## Tasks

# 1) Column end_activity_type contains both the activity type and activity's typical duration. Separate column into variables.

# 2) Column travel_distance is in meters. Make a new column which shows distance in kilometers. 

# 3) Filter trips to only include those whose destination is work

# 4) Remove all columns not having to do with travel time, travel distance, or mode. 

# 5) Make scatter plot comparing travel time and travel distance (in km), showing different colors per main_mode


# Bonus: very messy RKI data: 

# 6) Download RKI dataset and import "BL_7-Tage-Inzidenz (fixiert)" sheet using read_excel()
# https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab_Archiv.xlsx?__blob=publicationFile

# 7) Tidy the data

# 8) Make a plot of incidences over time 




