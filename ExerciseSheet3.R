library(tidyverse)
library(palmerpenguins)


peng <- penguins  # this is redundant, but it allows to view penguins tibble in Environment (upper right corner of RStudio)


## ggplot review
ggplot(data = peng) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g , linetype = species), se = FALSE)


## Dataframe (df) Basics
# view partial contents of df
peng
glimpse(peng)

# view full contents of df in seperate viewer
view(peng)

# dimensions 
dim(peng) # number of rows, number of columns

nrow(peng) # number of rows

ncol(peng) # number of columns 

# summary of each column in df 
summary(peng)

# subsetting
peng[,2] # returns tibble 
peng[,"island"] # returns tibble
peng$island # returns list

peng[50,2] # returnes 1x1 tibble
peng[[50,2]] # returns single value

# ------------------------------------------------------------------------------

### CHAPTER 5: Data transformation with dplyr

## mutate - "adds new variables that are functions of existing variables"
?mutate # read help article regarding mutate

#create column body_mass_kg, which converts body_mass_g into kilogram
mutate(peng, body_mass_kg = body_mass_g / 1000)

# create column long_flipper, which contains TRUE if flipper is longer than 190mm
mutate(peng, long_flipper = flipper_length_mm > 190)

# do both mutations in one step
mutate(peng, body_mass_kg = body_mass_g / 1000, 
       long_flipper = flipper_length_mm > 190)

# ------------------------------------------------------------------------------

## select - choose columns 
?select

# Keep columns: species, island, body_mass_g
select(peng, species, island, body_mass_g)

# Keep all columns except "sex" and "year"
select(peng, -c(sex,year))

# Keep all columns relating to the penguin's bill: bill_length_mm, bill_depth_mm (both start with "bill")
select(peng, starts_with("bill"))

# ------------------------------------------------------------------------------

## filter - "picks cases based on their values."
?filter

# Keep all penguins that have a has a bill length larger 55mm
filter(peng, bill_length_mm > 55)

# Keep all penguins that have a bill length longer than 55mm AND are of the "Chinstrap" species 
filter(peng, species == "Chinstrap", bill_length_mm > 55)
filter(peng, species == "Chinstrap" & bill_length_mm > 55)

# Keep all penguins that have a bill_length_mm > 55 OR are "Chinstrap" species 
filter(peng, bill_length_mm > 55 | species == "Chinstrap" )

# Apply more complex logic
filter(peng, species == "Adelie" & island == "Biscoe" & (body_mass_g < 3000 | body_mass_g > 4500))

# ------------------------------------------------------------------------------

## Pipes %>%
# old version to chain multiple operations
peng1 <- mutate(peng, body_mass_kg = body_mass_g / 1000)
peng2 <- select(peng1, species, island, body_mass_kg)
peng3 <- filter(peng2, body_mass_kg > 5.)

# new version using pipes
peng %>% mutate(body_mass_kg = body_mass_g / 1000) %>% 
  select(species, island, body_mass_kg) %>% 
  filter(body_mass_kg > 5.)

# ------------------------------------------------------------------------------

## Task Set #1: 
summary(p2)
# 1) mutate: create column approx_area, which is the product of bill length and depth; save resulting dataframe to p1
p1 <- peng %>% mutate(approx_area = bill_length_mm * bill_depth_mm)

# 2) select: remove bill_length_mm, bill_depth_mm, and flipper_length_mm columns from p1; save resulting dataframe to p2. 
p2 <- p1 %>% select(-c("bill_length_mm", "bill_depth_mm", "flipper_length_mm"))


# 3) filter: keep all penguins in dataframe p2 where the body_mass_kg is between 3000g and 5000g; save resulting dataframe to p3
p3 <- p2 %>% mutate(body_mass_kg = body_mass_g / 1000) %>% 
  filter(between(body_mass_kg,3,5))



# 4) Repeat questions 1-3 using the pipe operator ( %>% ); this means that the dataframes (p1, p2) are no longer necessary 
p4 <- peng %>% 
          mutate(approx_area = bill_length_mm * bill_depth_mm) %>% 
          select(-c("bill_length_mm", "bill_depth_mm", "flipper_length_mm")) %>% 
          mutate(body_mass_kg = body_mass_g / 1000) %>% 
          filter(between(body_mass_kg,3,5))
  


# 5) Bonus: add ggplot to the end of the piped statement from #4
p5 <- peng %>% 
  mutate(approx_area = bill_length_mm * bill_depth_mm) %>% 
  select(-c("bill_length_mm", "bill_depth_mm", "flipper_length_mm")) %>% 
  mutate(body_mass_kg = body_mass_g / 1000) %>% 
  filter(between(body_mass_kg,3,5)) %>% 
  ggplot()

# 6) Bonus: keep all penguins of dataframe "peng" where the bill_length is greater than the mean bill length using mean() within the filter function.
# If the results look weird, check the documentation for mean: ?mean
p6 <- peng %>% 
  mutate(approx_area = bill_length_mm * bill_depth_mm) %>% 
  filter(bill_length_mm> mean(na.omit(bill_depth_mm)))
  select(-c("bill_length_mm", "bill_depth_mm", "flipper_length_mm")) %>% 
  mutate(body_mass_kg = body_mass_g / 1000) %>% 
  filter(between(body_mass_kg,3,5))

# 7) Keep all columns relating to length: bill_length_mm, flipper_length_mm. Use a selection helper. 
p7 <- peng %>% select(ends_with('_length_mm'))


# ------------------------------------------------------------------------------

## summarise
?summarise

summarise(peng, avg_mass = mean(body_mass_g, na.rm = TRUE)) # without pipe
peng %>% summarise(avg_mass = mean(body_mass_g, na.rm = TRUE)) # with pipe

## group_by
peng %>% group_by(species) # note the "Groups" specification in the output -> 3 groups
peng %>% group_by(species, year) # -> 9 groups (3 species * 3 years)

# group_by + summarise

# find how many penguin observations were on each island and species 
peng %>% 
  group_by(species, island) %>% 
  summarise(penguin_cnt = n())

peng %>% 
  group_by(species, island) %>% 
  count()

peng %>% 
  group_by(species, island) %>%
  tally()


# find mean body mass for each penguin species: first group then summarise
peng %>% 
  group_by(species) %>%
  summarise(avg_mass = mean(body_mass_g, na.rm = TRUE))

# find max body mass for each species and island
peng %>% 
  group_by(species, island) %>%
  summarise(max_mass = max(body_mass_g, na.rm = TRUE))

# group_by + mutate + ungroup
peng %>% # without grouping
  mutate(max_mass = max(body_mass_g, na.rm = TRUE))

peng %>%
  group_by(sex) %>% # with grouping
  mutate(max_mass = max(body_mass_g, na.rm = TRUE)) %>% 
  ungroup()

# ------------------------------------------------------------------------------

## arrange
arrange(peng, bill_length_mm) # sort by bill_length_mm in ascending order
arrange(peng, desc(bill_length_mm)) # sort by bill_length_mm in descending order

arrange(peng, island, desc(bill_length_mm)) # sort by island (A -> Z) and then by bill_length_mm in descending order

# ------------------------------------------------------------------------------

## rename columns (NEW NAME = OLD NAME)
?rename
rename(peng, bl = bill_length_mm)
rename(peng, bl = bill_length_mm, fl = flipper_length_mm)

# ------------------------------------------------------------------------------

## Problem Set #2 

# 1) Calculate the median bill length per sex and year. 
p2.1 <- peng %>% 
  group_by(sex, year) %>% 
  summarise(med_bill_length = median(na.omit(bill_length_mm)))

# 2) For each penguin, calculate the difference it's bill_length and the mean bill_length for all penguins
p2.2 <- peng %>% 
  mutate(delta_to_mean_bill_length = bill_length_mm - mean(na.omit(bill_length_mm)))

# 3) For each penguin, calculate the difference it's bill_length and the mean bill_length for that penguin's species
p2.3 <- peng %>% 
  group_by(species) %>% 
  mutate(delta_to_mean_bill_length = bill_length_mm - mean(na.omit(bill_length_mm)))
  

# 4) using arrange, what species of penguin generally has shortest flippers?
p2.4 <- peng %>% 
  group_by(species) %>% 
  arrange(flipper_length_mm, .by_group = T)

# 5) using arrange, what island can you find the heaviest penguin?
p2.5 <- peng %>% 
  group_by(island) %>% 
  summarise(max_weight = max(na.omit(body_mass_g)))
  arrange(desc(max_weight), .by_group = T)




