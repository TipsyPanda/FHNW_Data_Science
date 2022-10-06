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
dataIn = "./Data/IN/Project/LCdata.csv"
dataOut = "./Data/Out/Project/LCdata_out.csv"
Lcdata_in <- read.csv(dataIn,header = TRUE, sep =';') 
lcdata <- Lcdata_in

summary(lcdata)


#View results
write.csv(lcdata,dataOut) 

View(lcdata)