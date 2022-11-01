#DataScience
#Exercise Sheet 2
#Tim Kirschbaum
#2022-10-24

#Task1 Introduction####
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g), colour = "blue")


#why is the colour not blue?!
#the colour argument isnt aes when its not plotting a variable. so hardcoded colour blue is an arguemnt of geom_point and not of aes

#Task2####
?penguins
# variables species, island and sex are categorical


#Task3####
ggplot(data = penguins)+
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = year, size = year, shape = sex))


#Task1 Facets####
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = sex))+
  facet_grid(~species)


#facet with continues var lets everything explode... generates as many facets as unique values exist

#Task2####
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = sex))+
  facet_grid(species~.)



#turns the facets

#Task1 Geometric Objects####
ggplot(penguins)+
  geom_point(aes(flipper_length_mm, body_mass_g))+
  geom_smooth(aes(flipper_length_mm, body_mass_g), color = "blue", se=F)

ggplot(penguins)+
  geom_point(aes(flipper_length_mm, body_mass_g))+
  geom_smooth(aes(flipper_length_mm, body_mass_g, group = species), color = "blue", se= F)

ggplot(penguins)+
  geom_point(aes(flipper_length_mm, body_mass_g, color = species))+
  geom_smooth(aes(flipper_length_mm, body_mass_g, color = species), se= F)

ggplot(penguins)+
  geom_point(aes(flipper_length_mm, body_mass_g, color = species))+
  geom_smooth(aes(flipper_length_mm, body_mass_g, linetype = species), se= F)

ggplot(penguins)+
  geom_point(aes(flipper_length_mm, body_mass_g, color = species))


#Task1 Coordinate sysetms####
penguins %>%
  ggplot(aes(x = factor(1) , fill = species)) +
  geom_bar()+
  theme_minimal ()+
  theme(legend.position="bottom")+
  coord_polar()


#Task2####
?labs()
#with labs axis and title and more can be manipulated


#Task1 Position Adjustments####

ggplot(data = mpg, mapping = aes(x = cty , y = hwy)) + 
  geom_jitter () +
  theme_minimal ()

#Task2####
?geom_jitter
#height and width can be used to adjust the jitter

#Task3####
ggplot(data = mpg, mapping = aes(x = cty , y = hwy)) + 
  geom_count () +
  theme_minimal ()

ggplot(data = mpg, mapping = aes(x = cty , y = hwy)) + 
  geom_jitter () +
  theme_minimal ()


#Task4####
?geom_boxplot
#default is position = "dodge2"


ggplot(mpg, aes(cty, hwy>=30))+
  geom_boxplot(position = "dodge2")






