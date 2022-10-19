#DataScience
#Exercise Sheet 1
#Tim Kirschbaum
#2022-10-19

#Task1####
modes <- c("walk", "bike", "car-driver", "car-passenger", "pt")

modes <- sort(modes)

modes <- as.numeric(modes) #doesn't work cause its a string... duffus

#Task2####
modal_split_paths <- c(11,43,14,10,22)

modal_split_paths <- modal_split_paths/100

modal_split_paths <- as.character(modal_split_paths) #turns num to char
modal_split_paths <- as.numeric(modal_split_paths) #set back to numeric

summary <- summary(modal_split_paths) 

greater0.15 <- modal_split_paths[modal_split_paths > 0.15]

#Task3####
df <- data.frame(modes = modes, modalsplit = modal_split_paths)

#Bonus1####
for (i in modes) {
  print(i)
}
rm(i)

#Bonus2####
for (i in modal_split_paths) {
  ifelse(i >= 0.4,
     print(i),"")
}
rm(i)



