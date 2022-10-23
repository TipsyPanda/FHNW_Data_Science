### Preliminaries
#install.packages("tidyr")
#install.packages("corrplot")
#install.packages("here")
#install.packages("fastDummies")
#install.packages("tm")
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("rcompanion")
#install.packages("DescTools")

library(rcompanion)
library(tidyr)
library(corrplot) 
library(fastDummies)
library(here)
library(tm)
library(tidyverse)
library(ggplot2)  
library(dplyr)
library(DescTools)

par(mfrow=c(1,1)) # set plotting window to default

# set printing preferences
options(scipen=99) # penalty for displaying scientific notation
options(digits=4) # suggested number of digits to display


#LOAD DATA
dataIn = "./Data/IN/Project/LCdata.csv"
dataOut = "./Data/Out/Project/LCdata_out.csv"
Lcdata_in <- read.csv(dataIn,header = TRUE, sep =';') 
View(Lcdata_in)
lcdata <- data.frame(Lcdata_in)

View(lcdata)
#Analyze Data
str(lcdata)
summary(lcdata)
# create a scatterplot of all features in the dataset and inspect it
#plot(lcdata)

attach(lcdata)

#Clean Data
source('./Scripts/DataCleaning/DataCleaning_C1-C10.R')
source('./Scripts/DataCleaning/DataCleaning_C11-C20.R')
source('./Scripts/DataCleaning/DataCleaning_C21-C30.R')
source('./Scripts/DataCleaning/DataCleaning_C31-C40.R')
source('./Scripts/DataCleaning/DataCleaning_C41-C50.R')
source('./Scripts/DataCleaning/DataCleaning_C51-C60.R')
source('./Scripts/DataCleaning/DataCleaning_C61-C72.R')


#View/store results
summary(lcdata)
#write.csv(lcdata,dataOut) 
View(lcdata)
