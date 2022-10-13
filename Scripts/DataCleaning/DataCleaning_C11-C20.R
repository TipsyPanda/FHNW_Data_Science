print("DataCleaning_C11-C20")

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

##C.13 Verification Status
  #Yannick - not verified
  #check values
  f <- factor(lcdata$verification_status)
  levels(f)
  table(f)
  
##C.14 issue_d
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
     lcdata$issue_d <- as.Date(paste0(lcdata$issue_d, "-01"), "%b-%Y-%d")
  
  #analyzing:
    #summary(lcdata$issue_d) 
    #hist(lcdata$issue_d,"months") #very left skewed

##C.15 Loan Status
  #Yannick - not verified
  #check values
  f <- factor(lcdata$loan_status)
  levels(f)
  table(f)
