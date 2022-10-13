### Preliminaries
#install.packages("tidyr")
#install.packages("corrplot")
#install.packages("here")
# install.packages("fastDummies")
library(tidyr)
library(corrplot) 
library(fastDummies)
library(here)

#LOAD DATA
dataIn = "./Data/IN/Cars/cgh_cars.csv"
dataOut = "./Data/Out/Cars/my_cars.csv"
cars_in <- read.csv(dataIn) 
View(cars_in)
my_cars <- cars_in

#drop ship
my_cars <- my_cars[my_cars$type != 'ship',]

my_cars <- dummy_cols(my_cars, select_columns="type", remove_selected_columns = TRUE)
#model as own columns
my_cars <- dummy_cols(my_cars, select_columns="brand", remove_selected_columns = TRUE)
#ordered style
my_cars$style <- as.integer(ordered(my_cars$style, levels= c("basic", "medium", "luxus")))

#Handle 0 cases
my_cars$mpg <- ifelse(my_cars$mpg == 0.0, NA, my_cars$mpg) 
#Handle NA cases
my_cars$mpg <- ifelse(is.na(my_cars$mpg),
                       mean(my_cars$mpg, na.rm=TRUE),
                      my_cars$mpg)


#Replace negative values in cyl
my_cars$cyl <- ifelse(my_cars$cyl <0 , abs(my_cars$cyl), my_cars$cyl)

#round gears
my_cars$gear<- round(my_cars$gear, digits = 0)

#remove weight outlines
while ( colSums(my_cars["wt"] %/% 10 > 0 ) > 0 ) 
{
  my_cars$wt <- ifelse(my_cars$wt > 10, my_cars$wt /10 ,my_cars$wt)
}

#Remove empty price rows
my_cars <- drop_na(my_cars,price)


#View results
corrplot(cor(my_cars), type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)
write.csv(my_cars,dataOut) 
View(my_cars)

#Test Kira git commit und push
View(my_cars$mpg)
