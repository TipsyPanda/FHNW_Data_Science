print("DataCleaning_C60-C72")
###Keep installments together "il"
#Number of currently active installment trades
##	C.59	open_il_6m
#Number of installment accounts opened in past 12 months
##	C.60	open_il_12m
#Number of installment accounts opened in past 24 months
##	C.61	open_il_24m
#Months since most recent installment accounts opened
##	C.62	mths_since_rcnt_il
#Total current balance of all installment accounts
##	C.63	total_bal_il
#Ratio of total current balance to high credit/credit limit on all install acct
##	C.64	il_util

##	C.65	open_rv_12m
##	C.66	open_rv_24m
##	C.67	max_bal_bc
##	C.68	all_util
##	C.69	total_rev_hi_lim
##	C.70	inq_fi
##	C.71	total_cu_tl
##	C.72	inq_last_12m

##C.59 open_il_6m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -open_il_6m)

##C.60	open_il_12m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -open_il_12m)

##C.61	open_il_24m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -open_il_24m)

##C.62	mths_since_rcnt_il
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -mths_since_rcnt_il)

##C.63	total_bal_il
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -total_bal_il)

##C.64	il_util
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -il_util)

##	C.65	open_rv_12m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -open_rv_12m)

##	C.66	open_rv_24m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -open_rv_24m)

##	C.67	max_bal_bc
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -max_bal_bc)

##	C.68	all_util
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -all_util)

##	C.69	total_rev_hi_lim
#Karsten - not verified
#Max 9999999 should be replaced by 0 "unlimited"
lcdata$total_rev_hi_lim[lcdata$total_rev_hi_lim == "9999999"] <- 0
#Outliers still far from Mean and Median, what to do against?

##	C.70	inq_fi
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -inq_fi)

##	C.71	total_cu_tl
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -total_cu_tl)

##	C.72	inq_last_12m
#Karsten - not verified
#Only data for roughly 2% of lines, drop it?
lcdata <- subset( lcdata, select = -inq_last_12m)
