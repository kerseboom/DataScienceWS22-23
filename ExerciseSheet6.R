
#If you weren't there for session 2 you need to use install.packages("palmerpenguins") first
library(palmerpenguins)
library(tidyverse)
library(ggrepel)
library(colorblindr)
library(BrailleR) #You probably need to install the package using install.packages("BrailleR") first. 
library(ggplot2)

penguins <- penguins

# Slide 5/6 -----------------------------------------------------------------

ggplot(data = penguins) +
  geom_point(aes(x = bill_depth_mm, y = bill_length_mm)) +
  facet_wrap(facets=vars(species)) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters"
  ) +
  theme_minimal(base_size = 18)


# Slide 7 -----------------------------------------------------------------

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  theme_minimal(base_size = 18) 

# Slide 9 -----------------------------------------------------------------

outliers <- penguins %>%
  group_by(species) %>%
  filter(bill_length_mm > mean(bill_length_mm, na.rm= TRUE) + 2.5*sd(bill_length_mm, na.rm= TRUE) | bill_length_mm < mean(bill_length_mm, na.rm= TRUE) - 2.5*sd(bill_length_mm, na.rm= TRUE))


# Slide 10/11 ----------------------------------------------------------------

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  theme_minimal(base_size = 18) +
  geom_text(data = outliers, aes(label = "Outlier"))

# Slide 12/13 ----------------------------------------------------------------

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  theme_minimal(base_size = 18) +
  geom_point(data = outliers, size = 3, shape = 1) +
  geom_label_repel(data = outliers, aes(label = "Outlier"))

# Slide 16 ----------------------------------------------------------------

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  theme_minimal(base_size = 18) +
  theme(legend.position = "bottom")

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 18) +
  theme(legend.position = "bottom")


# Slide 17 ----------------------------------------------------------------

ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species, shape=species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 18) +
  theme(legend.position = "bottom")


# Slide 20 ----------------------------------------------------------------

penguinplot <- ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species, shape=species)) +
  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins",
       subtitle = "Differentiation by species",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 18) +
  theme(legend.position = "bottom")

cvd_grid(penguinplot)

# Slide 22 ----------------------------------------------------------------

penguins %>% filter(species == "Chinstrap") %>%
  ggplot(aes(x=bill_depth_mm, y=bill_length_mm)) +
  coord_cartesian(xlim = c(19, 20.5))+
  labs(title ="Bill depth vs. bill length for Chinstrap penguins",
       subtitle = "Using coord_cartesian",
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  geom_point() +
  geom_smooth() +
  theme_minimal(base_size = 18) 

penguins %>% filter(species == "Chinstrap") %>%
  filter(bill_depth_mm > 19) %>%
  ggplot(aes(x=bill_depth_mm, y=bill_length_mm)) +
  labs(title = "Bill depth vs. bill length for Chinstrap penguins",
       subtitle = "Filtering first", 
       x = "Bill depth in millimeters",
       y = "Bill length in millimeters") +
  geom_point() +
  geom_smooth() +
  theme_minimal(base_size = 18 )


# Slide 27 ----------------------------------------------------------------

penguinplot <- ggplot(data = penguins, aes (x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species)) +
  #  geom_smooth(aes(color = species), method = lm, se=FALSE) +
  labs(title ="Bill depth vs. bill length for penguins", 
       subtitle = "Differentiation by species", 
       x = "Bill depth in millimeters", 
       y = "Bill length in millimeters") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal(base_size = 18) +
  theme(legend.position = "bottom")

BrailleR::VI.ggplot(penguinplot)



#task1####
p1 <- mpg %>% 
  ggplot(aes(displ, cty))+
  geom_point()+
  labs(title = "Citymiles per gallon on car engine displays", 
       subtitle = "hoihoi",
       x = "engine displacements in liter",
       y = "citymiles per gallon")

p1

#task5####
df <- tibble (
  x = rnorm (10000) , y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_colour_gradient(low = "#132B43" , high = "#56B1F7") + 
  coord_fixed ()




