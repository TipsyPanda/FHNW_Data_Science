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

library(gridExtra)
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
source('./Scripts/DataCleaning/DataCleaning_C51-C58.R')
source('./Scripts/DataCleaning/DataCleaning_C59-C72.R')


##View/store results
  summary(lcdata)
  View(lcdata)
 # write.table(lcdata, file = dataOut, sep = ";", col.names = NA,qmethod = "double")


## Define training and test data
  #Read clean file
  #Lcdata_clean <- data.frame(read.csv(dataOut,header = TRUE, sep =';'))
  Lcdata_clean <- lcdata
  # 75% of the sample size
  smp_size <- floor(0.1 * nrow(Lcdata_clean))
  
  # set the seed to make your partition reproducible
  set.seed(123)
  lcdata_ind <- sample(seq_len(nrow(Lcdata_clean)), size = smp_size)
  LCtrain <- as_tibble(Lcdata_clean[lcdata_ind, ])
  LCtest <- as_tibble(Lcdata_clean[-lcdata_ind, ])


  
##Reference Model
    # Start by using all the predictors in the dataset - backward selection
  hist(LCtrain$dti)
  # check correlation between the quantitative predictors
  LCtrain.sub <- LCtrain %>% select(int_rate, term, loan_amnt,dti,annual_inc,emp_length)
  p_mat <- cor(LCtrain.sub)
 
  # run plot
  corrplot(
    p_mat,
    title = "Dummy name here",
    method = "circle",
    type = "full",
    tl.col = "black",
    order = "hclust",
    hclust.method = "ward.D2",
    tl.cex = 1.2,
    cl.cex=1.2,
    outline = T,
    mar=c(0,0,4,5),
    sig.level = 0.05,
  )
  ggplot(LCtrain, aes(x=loan_amnt, y=int_rate)) + geom_point(aes(col="white"))

  lm.fit0 <- lm(int_rate~  dti, data=LCtrain)  
  summary(lm.fit0)
  confint(lm.fit0)
  plot(lm.fit0, which=1)
  
  
  lm.fit1 <- lm(int_rate~  purpose +term + dti+loan_amnt + emp_length, data=LCtrain)
  summary(lm.fit1)
  confint(lm.fit1)
  plot(lm.fit1, which=1)
  plot(lm.fit1, which=2)


  mean(lm.fit$residuals^2)
  
 
  

  

