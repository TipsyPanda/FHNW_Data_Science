### Preliminaries
#install.packages("tidyr")
#install.packages("corrplot")
library(tidyr)
library(corrplot) 
# install.packages("fastDummies")
library(fastDummies)
#install.packages("here")
library(here)

#LOAD DATA
dataIn = "./Data/IN/cgh_cars.csv"
dataOut = "./Data/Out/my_cars.csv"
my_cars <- read.csv(dataIn) 


#drop ship
my_cars <- my_cars[my_cars$type != 'ship',]

my_cars <- dummy_cols(my_cars, select_columns="type", remove_selected_columns = TRUE)
#model as own columns
my_cars <- dummy_cols(my_cars, select_columns="brand", remove_selected_columns = TRUE)
#ordered style
my_cars$style <- as.integer(ordered(my_cars$style, levels= c("basic", "medium", "luxus")))
#Handle NA cases

#Replace negative values in cyl
my_cars$cyl <- ifelse(my_cars$cyl <0 , abs(my_cars$cyl), my_cars$cyl)

#round gears
my_cars$gear<- round(my_cars, digits = 0)

#remove weight outlines


#View results
write.csv(my_cars,dataOut) 
View(my_cars)