print("DataCleaning_C21-C30")

##C.21 zip_code
#Yannick - not verified
summary(lcdata$zip_code)
lcdata$zip_code

##C.25 earliest_cr_line
#Yannick - not verified

#format as date (add first day of the month then convert to ISO)
lcdata$earliest_cr_line <- as.Date(paste0(lcdata$earliest_cr_line, "-01"), "%b-%Y-%d")
summary(lcdata$earliest_cr_line)
