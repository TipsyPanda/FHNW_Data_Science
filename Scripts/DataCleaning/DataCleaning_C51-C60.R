print("DataCleaning_C51-C60")

##C.51 application_type
#Yannick - not verified

#factorize 
lcdata$application_type <- as.factor(lcdata$application_type)
summary(lcdata$application_type)