print("DataCleaning_C51-C60")
##	C.51	application_type
##	C.52	annual_inc_joint
##	C.53	dti_joint
##	C.54	verification_status_joint
##	C.55	acc_now_delinq
##	C.56	tot_coll_amt
##	C.57	tot_cur_bal
##	C.58	open_acc_6m
##	C.59	open_il_6m
##	C.60	open_il_12m

##C.51 application_type
  #Yannick - not verified

  #factorize 
  lcdata$application_type <- as.factor(lcdata$application_type)
  summary(lcdata$application_type)

##C.51 verification_status_joint
  #Yannick - not verified
    lcdata$verification_status_joint <- as.factor(lcdata$verification_status_joint)
    summary(lcdata$verification_status_joint)
    #todo: map source verified to verified
  