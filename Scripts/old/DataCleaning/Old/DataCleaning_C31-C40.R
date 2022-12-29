print("DataCleaning_C31-C40")
##	C.31	revol_bal
##	C.32	revol_util
##	C.33	total_acc
##	C.34	initial_list_status
##	C.35	out_prncp
##	C.36	out_prncp_inv
##	C.37	total_pymnt
##	C.38	total_pymnt_inv
##	C.39	total_rec_prncp
##	C.40	total_rec_int



##C.34	initial_list_status
  #Yannick - not verified
    #factorize 
    lcdata$initial_list_status <- as.factor(lcdata$initial_list_status)
    summary(lcdata$initial_list_status)
    