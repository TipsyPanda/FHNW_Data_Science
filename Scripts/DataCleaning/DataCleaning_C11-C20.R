print("DataCleaning_C11-C20")

##C.11 Home Ownership
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
  #check values
  f <- factor(lcdata$verification_status)
  levels(f)
  table(f)
  
##C.15 Loan Status
  #check values
  f <- factor(lcdata$loan_status)
  levels(f)
  table(f)
