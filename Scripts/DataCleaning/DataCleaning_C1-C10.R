print("DataCleaning_C1-C10")

##	C.1	id
##	C.2	member_id
##	C.3	loan_amnt
##	C.4	funded_amnt
##	C.5	funded_amnt_inv
##	C.6	term
##	C.7	int_rate
##	C.8	installment
##	C.9	emp_title
##	C.10	emp_length

require("tm")
all_stops <- c("months", "years", "year")

##C1.id
  #Karsten, Not reviewed
  #ID should be dropped 
  lcdata <- subset( lcdata, select = -id)
  
##C2.member_id
  #Karsten, Not reviewed
  #member_id should be dropped
  lcdata <- subset( lcdata, select = -member_id)

##C6.Term
  #Unknown, Not reviewed
  f <- factor(lcdata$term)
  levels(f)
  lcdata$term <- as.integer(removeWords(lcdata$term, all_stops))

##C9.Emp_title
  #Unknown, Not reviewed
  f <- factor(lcdata$emp_title)
  levels(f)

###C10.Emp_lengt
  #Yannick, Not reviewed
  r <- summary(lcdata$emp_length, na.rm = TRUE)
  r
  f <- factor(lcdata$emp_length)
  levels(f)
  table(f)


  #handle <1 and +10
  lcdata$emp_length = case_when(
    lcdata$emp_length == "< 1 year"  ~ '0',
    lcdata$emp_length == "10+ years"  ~ '10',
    TRUE ~ lcdata$emp_length
  )
  #Remove year/s and suppress NA introduction warning
  lcdata$emp_length <-
    suppressWarnings(as.integer(removeWords(lcdata$emp_length, all_stops)))
  
  #Handle NA cases by replacing NA with the mean value. Mean and Median are almost identical.
  r <- summary(lcdata$emp_length, na.rm = TRUE)
  r
  r <-
    round(mean(as.integer(lcdata$emp_length), na.rm = TRUE), digits = 0)
  lcdata$emp_length <-
    ifelse(is.na(lcdata$emp_length), r,
           as.integer(lcdata$emp_length))
  
  
