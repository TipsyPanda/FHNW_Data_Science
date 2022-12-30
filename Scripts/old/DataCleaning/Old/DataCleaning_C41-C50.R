print("DataCleaning_C41-C50")
##	C.41	total_rec_late_fee
##	C.42	recoveries
##	C.43	collection_recovery_fee
##	C.44	last_pymnt_d
##	C.45	last_pymnt_amnt
##	C.46	next_pymnt_d
##	C.47	last_credit_pull_d
##	C.48	collections_12_mths_ex_med
##	C.49	mths_since_last_major_derog
##	C.50	policy_code

##C.44 last_pymnt_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$last_pymnt_d <- as.Date(paste0(lcdata$last_pymnt_d, "-01"), "%b-%Y-%d")
  summary(lcdata$last_pymnt_d)

##C.46 next_pymnt_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$next_pymnt_d <- as.Date(paste0(lcdata$next_pymnt_d, "-01"), "%b-%Y-%d")
  summary(lcdata$next_pymnt_d)

##C.47 last_credit_pull_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$last_credit_pull_d <- as.Date(paste0(lcdata$last_credit_pull_d, "-01"), "%b-%Y-%d")
  summary(lcdata$last_credit_pull_d)
  