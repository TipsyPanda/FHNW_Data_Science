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
#install.packages("caret")
#install.packages("Matrix")
#install.packages("rlang")

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
library(caret)

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
  Lcdata_clean_subset  <- lcdata %>% select(int_rate, term, loan_amnt,dti,annual_inc,
                                            emp_length,funded_amnt ,funded_amnt_inv,term ,installment,home_ownership)
  # 75% of the sample size
  smp_size <- floor(0.1 * nrow(Lcdata_clean_subset))
  
  # set the seed to make your partition reproducible
  set.seed(123)
  lcdata_ind <- sample(seq_len(nrow(Lcdata_clean_subset)), size = smp_size)
  LCtrain <- as_tibble(Lcdata_clean_subset[lcdata_ind, ])
  LCtest <- as_tibble(Lcdata_clean_subset[-lcdata_ind, ])


  
##Reference Model
    # Start by using all the predictors in the dataset - backward selection

  # check correlation between the quantitative predictors

  pairs( LCtrain)
  p_mat <- cor(LCtrain)
 
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


  ### k fold ###

  #specify the cross-validation method
  ctrl <- trainControl(method = "cv", number = 10)
  
  ##Model 0
  
  #fit a regression model and use k-fold CV to evaluate performance
  lm.fit0 <- train(int_rate~  term + dti, data = LCtrain, method = "lm", trControl = ctrl)
  
  #view summary of k-fold CV               
  print(lm.fit0)
  
  #  RMSE  Rsquared  MAE  
  #3.92  0.1973    3.163
  

  
   ## Model 1 - adding additonal parameters (manual selection)
  
  
  #fit a regression model and use k-fold CV to evaluate performance
  lm.fit1 <- train(int_rate~ purpose + term + dti+loan_amnt + emp_length, data = LCtrain, method = "lm", trControl = ctrl)
  
  #view summary of k-fold CV               
  print(lm.fit1)
  summary(lm.fit1)
  
  #  RMSE  Rsquared  MAE  - improvement over Model 0
  #3.799  0.246     3.068
  

  
  ## Model 2 - adding purpose as parameter

  
  #fit a regression model and use k-fold CV to evaluate performance
  lm.fit2 <- train(int_rate~ purpose + term + dti+loan_amnt + emp_length, data = LCtrain, method = "lm", trControl = ctrl)
  
  #view summary of k-fold CV               
  print(lm.fit2)
  summary(lm.fit2)
  
  #  RMSE  Rsquared  MAE  - improvement over Modelo
  #3.799  0.246     3.068
 

  
### Try automated feature selection
  # Model with all variables
  mod_all <- lm(int_rate ~ ., data=LCtrain)
  AIC(mod_all)
  summary(mod_all)$r.squared

  # Intercept only model
  mod0 <- lm(int_rate  ~ 1, data=LCtrain)
  AIC(mod0)
  summary(mod0)$r.squared

  summary(LCtrain)
  
  ##Forward
  library(MASS)
  fmod <- stepAIC(object = mod0, direction = "forward", 
                  scope = formula(mod_all), trace=FALSE)
  coef(fmod)

  AIC(fmod)

  summary(fmod)$r.squared
  
  fmod$anova

  ##Backwards

  bmod <- stepAIC(mod_all, direction = "backward", 
                 scope = formula(mod0), trace=FALSE)
  coef(bmod)
 
  AIC(bmod)

  summary(bmod)$r.squared
  bmod$anova

  
  ##mixed mode
  smod <- stepAIC(mod_all, direction = "both", trace=FALSE)
  coef(smod)
  AIC(smod)
  summary(smod)$r.squared
  smod$anova
  
  
  ##combine with k fold --> to be moved to other k fold
  set.seed(1234)
  set_train <- trainControl(method="repeatedcv", number=10, repeats=3)
  cvmod <- train(int_rate ~ ., data=LCtrain,  scope = formula(mod0),
                 method="lmStepAIC", direction="backward", trace=FALSE, trControl=set_train)
  coef(cvmod$finalModel)
  AIC(cvmod$finalModel)

  
