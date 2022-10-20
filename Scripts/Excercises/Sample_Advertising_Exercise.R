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
dataIn = "./Data/IN/Advertising/Advertising.csv"
dataOut = "./Data/Out/Advertising/Advertising.csv"
ads_in <- read.csv(dataIn) 
View(ads_in)
ads <- ads_in
attach(ads)
dim(ads)
summary(ads)

plot(TV,sales)
plot(ads)

fit1 <- lm(sales ~., data=ads )
summary(fit1)


fit5 <- lm(sales~TV,data=ads )
summary(fit5)
plot(fit5, which=1)


confint(fit5)
  

lm.fit1 = lm(data=ads,formula = sales~TV+radio+newspaper)


conf_interval = predict(fit5, data.frame(TV=c(100,150,200)), interval="confidence") 

pred_interval = predict(fit5, data.frame(TV=c(100,150,200)), interval="prediction")


