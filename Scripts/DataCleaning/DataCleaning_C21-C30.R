print("DataCleaning_C21-C30")
##	C.21	zip_code
##	C.22	addr_state
##	C.23	dti
##	C.24	delinq_2yrs
##	C.25	earliest_cr_line
##	C.26	inq_last_6mths
##	C.27	mths_since_last_delinq
##	C.28	mths_since_last_record
##	C.29	open_acc
##	C.30	pub_rec


##C.21 zip_code
  #Yannick - not verified
  #split zip codes by Area (first digit) and region (2nd and 3rd digit) and drop the original column
  lcdata$zip_code_area <- as.factor(substr(lcdata$zip_code,1,1))
  lcdata$zip_code_region <- as.factor(substr(lcdata$zip_code,2,3))
  lcdata <- subset( lcdata, select = -zip_code)
  

##C.22 addr_state
  #Yannick - not verified 
  lcdata$addr_state <-  as.factor(lcdata$addr_state)

  #experimental :anzalyze relation between state and zip code area
  short_lcdata <- tail(lcdata,5000)
  # p1 <-  ggplot(short_lcdata, aes(x=addr_state,y=zip_code_area))+ geom_point() #+   geom_jitter(width = 0.5, height = 0.5)
  # plot(p1)
  # p2 <- ggplot(lcdata, aes(x=zip_code_area)) + geom_point(color="black", fill="white")
  # grid.arrange(p1, p2, nrow = 1)
  # par(mfrow=c(1,1))
  # cor(lcdata$zip_code_area, lcdata$addr_state )
  # #calculate cramerV.
  # install.packages("rcompanion")
  # library(rcompanion)
  # cramerV(lcdata$zip_code_area, lcdata$addr_state )
  # cramerV(lcdata$zip_code_region, lcdata$addr_state )
  # df <- data.frame(lcdata$zip_code_area, lcdata$addr_state)
  # plot(df)
  
##C.25 dti
  #Yannick - not verified
  #remove outliers with dti over 100%
  lcdata<-subset(lcdata, lcdata$dti < 100)
             
##C.25 earliest_cr_line
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$earliest_cr_line <- as.Date(paste0(lcdata$earliest_cr_line, "-01"), "%b-%Y-%d")
  summary(lcdata$earliest_cr_line)
