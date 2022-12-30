print("DataCleaning_C11-C20")
##	C.11	home_ownership
##	C.12	annual_inc
##	C.13	verification_status
##	C.14	issue_d
##	C.15	loan_status
##	C.16	pymnt_plan
##	C.17	url
##	C.18	desc
##	C.19	purpose
##	C.20	title

##C.11 Home Ownership
  #Yannick - not verified
  #check values
  f <- factor(lcdata$home_ownership)
  levels(f)
  table(f)
  #map Any and none to Other as they are not accepted values
  lcdata$home_ownership = case_when(
    lcdata$home_ownership == "ANY" ~ "OTHER",
    lcdata$home_ownership == "NONE"  ~ "OTHER",
    TRUE ~ lcdata$home_ownership)
    
  #put them in order with owning has highest value and other as lowest
  lcdata$home_ownership <- as.integer(ordered(lcdata$home_ownership, levels= c("OTHER", "RENT", "MORTGAGE", "OWN")))
  
##	C.12	annual_inc
  #Overview
  plot(lcdata$annual_inc)
  hist(lcdata$annual_inc)
  boxplot(lcdata$annual_inc)
  summary(lcdata$annual_inc)

  
  #remove NA by replacing them with median income (only 4 so not analyzed in detail)
  r <- round(median(as.integer(lcdata$annual_inc), na.rm = TRUE), digits = 0)
  lcdata$annual_inc <-
    ifelse(is.na(lcdata$annual_inc), r,
           as.integer(lcdata$annual_inc))

  #analyze distribution --> high amount of outliers with high incomes
  plot(lcdata$annual_inc)
  hist(lcdata$annual_inc)
  boxplot(lcdata$annual_inc)
  
  #winsorize data to move outliers into a reasonable range instead of removing them to keep the high income segment
  data <- lcdata$annual_inc
  length(data)
  data_no_outlier <- Winsorize(data, probs = c(0.05, 0.95))
  
  #verify result. 
  boxplot(data_no_outlier)
  hist(data_no_outlier)
  
  #normalize the data into 0-1
  x <- data_no_outlier
  data_no_outlier_norm = (x-min(x))/(max(x)-min(x))
  hist(data_no_outlier_norm)
  summary(data_no_outlier_norm)
  
  #save data back to main data set
  lcdata$annual_inc <- data_no_outlier_norm
  
  

##C.13 Verification Status
  #Yannick - not verified
  #factorize
  lcdata$verification_status <- as.factor(lcdata$verification_status)

##C.14 issue_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
     lcdata$issue_d <- as.Date(paste0(lcdata$issue_d, "-01"), "%b-%Y-%d")
  
  #analyzing:
    #summary(lcdata$issue_d) 
    #hist(lcdata$issue_d,"months") #very left skewed

##C.15 loan_status
  #Yannick - not verified
     #factorize 
     lcdata$loan_status <- as.factor(lcdata$loan_status)
     summary(lcdata$loan_status)
     
##C.16	pymnt_plan
     #Yannick - not verified
     #factorize 
     lcdata$pymnt_plan <- as.factor(lcdata$pymnt_plan)
     summary(lcdata$pymnt_plan)
     
##C.17	url
     #Yannick - not verified
     #url should be dropped
     lcdata <- subset( lcdata, select = -url)
     
##C.18	desc
     #Yannick - not verified
     #desc should be dropped
     lcdata <- subset( lcdata, select = -desc)
     
##C.19	purpose
     #Yannick - not verified
     lcdata$purpose <- as.factor(lcdata$purpose)
     summary(lcdata$purpose)

     
##C.20	title
     #Yannick - not verified
     #title should be dropped
     lcdata <- subset( lcdata, select = -title)

     