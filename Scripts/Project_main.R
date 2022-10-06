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
lcdata <- Lcdata_in



summary(lcdata)

#C6.Term 
f <- factor(lcdata$term)
levels(f)
require("tm")
lcdata$term <- as.integer(removeWords(lcdata$term,"months"))




#View results
#write.csv(lcdata,dataOut) 

View(lcdata)
