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

     