### Preliminaries
#install.packages("tidyr")
#install.packages("corrplot")
#install.packages("here")
# install.packages("fastDummies")
# install.packages("tm")
library(tidyr)
library(corrplot) 
library(fastDummies)
library(here)
library(tm)


#LOAD DATA
dataIn = "./Data/IN/Project/LCdata.csv"
dataOut = "./Data/Out/Project/LCdata_out.csv"
Lcdata_in <- read.csv(dataIn,header = TRUE, sep =';') 
lcdata <- data.frame(Lcdata_in)


#Analyze Data
summary(lcdata)
# create a scatterplot of all features in the dataset and inspect it
#plot(lcdata)

#Clean Data

source('./Scripts/DataCleaning/DataCleaning_C1-C10.R')
source('./Scripts/DataCleaning/DataCleaning_C11-C20.R')
source('./Scripts/DataCleaning/DataCleaning_C21-C30.R')


#View/store results
summary(lcdata)
#write.csv(lcdata,dataOut) 
View(lcdata)
