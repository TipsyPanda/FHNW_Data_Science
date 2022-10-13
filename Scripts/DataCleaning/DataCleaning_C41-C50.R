print("DataCleaning_C41-C50")

##C.42 last_pymnt_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$last_pymnt_d <- as.Date(paste0(lcdata$last_pymnt_d, "-01"), "%b-%Y-%d")
  summary(lcdata$last_pymnt_d)

##C.44 next_pymnt_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$next_pymnt_d <- as.Date(paste0(lcdata$next_pymnt_d, "-01"), "%b-%Y-%d")
  summary(lcdata$next_pymnt_d)

##C.45 last_credit_pull_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$last_credit_pull_d <- as.Date(paste0(lcdata$last_credit_pull_d, "-01"), "%b-%Y-%d")
  summary(lcdata$last_credit_pull_d)
