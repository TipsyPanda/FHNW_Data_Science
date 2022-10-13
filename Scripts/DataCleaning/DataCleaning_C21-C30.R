print("DataCleaning_C21-C30")

##C.21 zip_code
  #Yannick - not verified
  #split zip codes by Area (first digit) and region (2nd and 3rd digit) and drop the original column
  lcdata$zip_code_area <- as.factor(substr(lcdata$zip_code,1,1))
  lcdata$zip_code_region <- as.factor(substr(lcdata$zip_code,2,3))
  lcdata <- subset( lcdata, select = -zip_code)
  

##C.22 addr_state
  #Yannick - not verified 
  lcdata$addr_state <-  as.factor(lcdata$addr_state)

  #anzalyze relation between state and zip code area
  p1 <-  ggplot(lcdata, aes(x=addr_state,y=zip_code_area))+ geom_point() + geom_jitter()
  plot(p1)
  p2 <- ggplot(lcdata, aes(x=zip_code_area)) + geom_point(color="black", fill="white")
  grid.arrange(p1, p2, nrow = 1)
  par(mfrow=c(1,1))
  cor(lcdata$zip_code_area, lcdata$addr_state )
  #calculate cramerV. 
  install.packages("rcompanion")
  library(rcompanion)
  cramerV(lcdata$zip_code_area, lcdata$addr_state )
  cramerV(lcdata$zip_code_region, lcdata$addr_state )
  df <- data.frame(lcdata$zip_code_area, lcdata$addr_state)
  plot(df)
  
         
##C.25 earliest_cr_line
  #Yannick - not verified
  
  #format as date (add first day of the month then convert to ISO)
  lcdata$earliest_cr_line <- as.Date(paste0(lcdata$earliest_cr_line, "-01"), "%b-%Y-%d")
  summary(lcdata$earliest_cr_line)
