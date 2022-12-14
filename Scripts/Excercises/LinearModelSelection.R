#####################################################
# Data Science
# W03 Resampling, Model Slection and Regularization
# Dr. Gwendolin Wilke
# gwendolin.wilke@fhnw.ch
#####################################################


##############   PRELIMINARIES   ##########################

# load libraries
library(ISLR)      # contains textbook data
library(tidyverse) # for nice plots, include automatically ggplot2 and other utilities

# get rid of old stuff
rm(list = ls()) # clear environment
par(mfrow = c(1, 1)) # set plotting window to default

# set printing preferences
options(scipen = 99) # penalty for displaying scientific notation
options(digits = 4) # suggested number of digits to display

##############   DATA SET   ##########################

# Read description of data set
?Credit
#In this exercise, we try to predict the credit card balance from the other variables.

# We transform Credit into a tibble, which is the advanced version of a data frame
Cr1 <- as_tibble(Credit)   

# Examine Data Set
summary(Cr1)
# We see here that we have 12 attributes. We want to predict balance, which leaves us with 11 predictors.
# 4 of the predictors are categorical, i.e., they need to be converted in dummy variables.
attach(Cr1)
plot(Balance ~ ., data = Cr1)

pairs(Cr1) # Use zoom in plot window to see it better
# Notice in the pairs plot that Limit & rating, as well as Limit and income are highly collinear. 
# Thats not surprising, since limit and rating of a bank is probably mainly determined by income.
# For linear regression, collinear predictors are not good, because they make coefficient estimates highly unstable! 
# We might want to exclude some of those predictors for our fit.
# We double-check with pearsons correlation index:
cor(Limit, Rating) 
cor(Limit, Income) 
cor(Rating, Income)
# Notice also that Rating and Limit are collinear with Balance, so maybe good predictors for Balance.
cor(Limit, Balance)
cor(Rating, Balance)
# Income may be an ok predictor:
cor(Income, Balance)


############ BEST SUBSET SELECTION ############

# The Best Subset Selection Algo consists of 3 Steps:
# 1. Initializing the null model.
# 2. For each fixed model size k, choose the best model using RSS.
# 3. Choose the best k using
#       - one of AIC, BIC, Cp, Adjusted R2, or
#       - cross validation error.

# We use the function regsubsets().This function only performs steps 1+2 of our Best Subset Selection Algo:
# For each fixed model size k, it chooses the best model using RSS.
# It does NOT select the best model size k for us, though. 
# I.e., Step 3 of the Best Subset Selection Algo is not covered by regstubsets(), and we need to do it manually.
# We do it in both ways: First we use AIC, BIC, Cp and Adjustes R2, then we do the same task again with cross validation.


############ Choosing the best model per model size k (Algo Step 1+2) ############

# We use the function regsubsets() to select the best subset for each fixed model size k
# Here, "best" is quantified using RSS. 
# The syntax is the same as for lm(). 

# install the package "leaps" if not already present. It contains regsubsets().
# install.packages("leaps")

# We load the library "leaps" 
library("leaps")

sets <- regsubsets(Balance ~ ., Cr1, nvmax = 12) 
# nvmax specifies the maximum size of subsets to examine. 
# We chose nvmax=12, even though we only have 11 predictors. 
# The reason is that Ethnicity is split up into 3 dummy variables, 
# one of which goes to the intercept. In total we end up with 12 variables, see the summary below.
# Use the parameters force.in and force.out, if you want to make sure a predictor is (de-)selected.
# See helo for more detail.

# The summary() command outputs the best set of variables for each model size according to RSS. 
# Here, an asterisk indicates that a given variable is included in the corresponding model.
(sets_summary <- summary(sets)) 


############ Using AdjR2, Cp and BIC to find the best model size (Algo Step 3, possibility 1) ############

# We now want to select the best model size for our data set. 
# To do this, we can use one or all of the metrics Adjusted R^2, AIC, Cp or BIC.
# With the exception of AIC, regsubsets() stores them in its summary. We only use the 3 metrics that regsubsets() provides.
# NOTICE: Since we applied regsubsets() to the whole data set, the metrics are training error metrics.

# We first  inspect the output of regsubsets() a bit closer.
# It stores the values of the metrics RSS, R^2, Adjusted R^2, Cp and BIC for eauch of the 12 best performing models:
names(sets_summary)  

# Let's view them all together
data.frame("rsq"=sets_summary$rsq, "adjr2"=sets_summary$adjr2, "cp"=sets_summary$cp, "bic"=sets_summary$bic)

# We now look up which model has the highest RSS and R^2 value. (The lower RSS the better, the higher R^2 the better!)
# Remeber that RSS and R^2 is not useful in Step3 of the Algo, because its monotonically growing with k. 
# We just look it up to confirm what we already know...
# which.max returns the index of the vector sets_summary$rsq that stores the highest value
(rsq.max <- which.max(sets_summary$rsq)) 
(rss.min <- which.min(sets_summary$rss)) 

# We look up which model has the highest Adjusted R^2 value. (The higher the Adjusted R^2 the better!) 
(adjR2.max <- which.max(sets_summary$adjr2))

# We look up which model has the highest Cp and BIC values. (The lower the values the better!)
(cp.max <- which.min(sets_summary$cp))
(bic.max <- which.min(sets_summary$bic))


# To get a better picture, we can additionally plot the 3 metrics Adjusted R^2,Cp and BIC as linegraphs as a function of the number of predictors.
# We mark the "winner" for each metric 

steps <- 1:12 # First we need to define the x-axes (holdimg the number of predictors). For this we construct the vector 1,2,3,...,12

# In the first plot we put the Adjusted R^2
#   Line 4 inserts a cross for the "winner":
#       - adjR2.max gives us the index (i.e. the x-value) of the winner
#       - sets_summary$adjr2[adjR2.max] gives us the corresponding R^2 value
#       - shape=4 plots a cross instead of a point

p1 <- ggplot() + # set up ggplot
  geom_point(aes(x = steps, y = sets_summary$adjr2), color = "black", size = 2) + # plot the points
  geom_line(aes(x = steps, y = sets_summary$adjr2), color = "black", size = 0.5) + # connect them with lines
  geom_point(aes(x = adjR2.max, y = sets_summary$adjr2[adjR2.max]), color = "black", size = 7, shape = 4) + 
  xlab("Number of predictors") + ylab("Adjuster R squared")

# In the second plot we put Cp and BIC

p2 <- ggplot() +
  geom_point(aes(x = steps, y = sets_summary$cp), color = "blue", size = 2) +
  geom_line(aes(x = steps, y = sets_summary$cp), color = "blue", size = 0.5) +
  geom_point(aes(x = cp.max, y = sets_summary$cp[cp.max]),color = "blue", size = 7, shape = 4) +
  geom_point(aes(x = steps, y = sets_summary$bic), color = "red", size = 2) +
  geom_line(aes(x = steps, y = sets_summary$bic), color = "red", size = 0.5) +
  geom_point(aes(x = bic.max, y = sets_summary$bic[bic.max]), color = "red", size = 5, shape = 4) +
  xlab("Number of predictors") + ylab("Cp (blue) , BIC (red) ")

library(gridExtra) # load the library gridExtra to use gridarrange() 
grid.arrange(p1, p2, nrow = 2) # plot

# In these plots we see that non of the metrics seem to chang much after k=4 predictors. 
# Does it matter which one we choose?
# For interpretability reasons, less predictors are better. So, we could choose the model with k=4.
# 

# Alternatively we visualize the "winner" for each metric in the following plot:
# The regsubsets() function has a built-in plot() command. 
# For each metric, it plots a table, with 12 rows for the 12 models, ordered by metric (best metric is top row)
# The columns show which predictors are included in each model.
# We can find the winner for each metric in the uppermost row.
# Using these plots has the advantage that we can directly see which predictors are included in the winning model.
# To find out more about this function, type ?plot.regsubsets.
?plot.regsubsets

par(mfrow=c(1,3)) # set a grid for the plotting window
plot(sets, scale="adjr2")
plot(sets, scale="Cp")
plot(sets, scale="bic")
par(mfrow=c(1,1))

# Also in this plot, we see that a lot of models share the same or almost the same values after 4.
# Not surprisingly, model 4 contains Income and Limit. 
# If we would inspect the actual model fit, we would see that both are significant (since their collinearity is not too bad).
# Models 6 and 7 both add Rating, which is not highly significant, (an expected effect of collinearity with Limit). 
# We could run the fit again and use the parameter force.out to exclude Rating... 
# (Which of teh collinear predictors to force.out is more a domain inspired decision.)
# 
# There is no clear winner, but we might prefer the smaller model 4.


############ Using cross validation error to find the best model size (Algo Step3, possibility 2) ############

# In the previous section, we used the metrics Adjusted R^2, Cp and BIC  
# as returned by regsubsets(). Since regsubset was applied to the whole data set,
# these metrics are metrics for the training error. 

# It is much better to use cross validation, because it is a stable form of test error.
# To do this, we fit all of the models that regsubset() has given us using the glm() function,
# because glm() gives us the function cv.glm to apply cross validation easily.
# Notice that we only fit 11 models, because Ethnicity is split up by glm in 2 dummy variables automatically.

# Fit the models using glm
initialize 
glm1 <- glm(Balance ~ Rating, data=Cr1) 
glm2 <- glm(Balance ~ Income + Rating, data=Cr1) 
glm3 <- glm(Balance ~ Income + Rating + Student, data=Cr1) 
glm4 <- glm(Balance ~ Income + Limit + Cards + Student, data=Cr1) 
glm5 <- glm(Balance ~ Income + Limit + Rating + Cards + Student, data = Cr1)
glm6 <- glm(Balance ~ Income + Limit + Rating + Cards + Age + Student, data = Cr1)
glm7 <- glm(Balance ~ Income + Limit + Rating + Cards + Age + Gender + Student, data=Cr1) 
glm8 <- glm(Balance ~ ID + Income + Limit + Rating + Cards + Age + Gender + Student, data=Cr1)
glm9 <- glm(Balance ~ ID + Income + Limit + Rating + Cards + Age + Gender + Student + Ethnicity, data=Cr1)
glm10 <- glm(Balance ~ ID + Income + Limit + Rating + Cards + Age + Gender + Student + Married + Ethnicity, data=Cr1)
glm11 <- glm(Balance ~ ID + Income + Limit + Rating + Cards + Age + Education + Gender + Student + Married + Ethnicity, data=Cr1)

# We do 10-fold CV
library(boot) # load library boot to use cv.glm
set.seed(1)
cv.err.glm1 <- cv.glm(Cr1, glm1, K = 10) 
cv.err.glm2 <- cv.glm(Cr1, glm2, K = 10) 
cv.err.glm3 <- cv.glm(Cr1, glm3, K = 10) 
cv.err.glm4 <- cv.glm(Cr1, glm4, K = 10) 
cv.err.glm5 <- cv.glm(Cr1, glm5, K = 10)
cv.err.glm6 <- cv.glm(Cr1, glm6, K = 10) 
cv.err.glm7 <- cv.glm(Cr1, glm7, K = 10) 
cv.err.glm8 <- cv.glm(Cr1, glm8, K = 10)
cv.err.glm9 <- cv.glm(Cr1, glm9, K = 10)
cv.err.glm10 <- cv.glm(Cr1, glm10, K = 10)
cv.err.glm11 <- cv.glm(Cr1, glm11, K = 10)

# We plot the CV error as a function of the number of predicors
x <- 1:11 # define the x-axes (number of predictors)
(cv.err <- c(cv.err.glm1$delta[1], cv.err.glm2$delta[1], cv.err.glm3$delta[1], cv.err.glm4$delta[1], 
             cv.err.glm5$delta[1],cv.err.glm6$delta[1],cv.err.glm7$delta[1], cv.err.glm8$delta[1], cv.err.glm9$delta[1], cv.err.glm10$delta[1], cv.err.glm11$delta[1]))
plot(cv.err ~x)
lines(cv.err ~x)
# Here it's hard again to see which model wins. 

# To see it more clearly, we find the minimum:
(cv.min <- which.min(cv.err))
cv.err[cv.min]

# Which model is it?
coef(sets,7)
# Inspect the coefficient estimates
summary(glm7)
# Rating, Age and Gender are significant, but much less than the other predictors.

# Compare it with the other winning models of the last subsection
coef(sets,6)
summary(glm6)

# We see that Gender was added as a predictor
coef(sets,4)
summary(glm4)

# Compare all 4 metrics (AdjR2, Cp, BIC, Ccv-error) of all 3 models
data.frame("predictors"= c(4,6,7), 
           "cv-err"=c(cv.err.glm4$delta[1], cv.err.glm6$delta[1], cv.err.glm7$delta[1]),
           "adjR2"=c(sets_summary$adjr2[4], sets_summary$adjr2[6], sets_summary$adjr2[7]),
           "Cp"=c(sets_summary$cp[4], sets_summary$cp[6], sets_summary$cp[7]),
           "BIC"=c(sets_summary$bic[4], sets_summary$bic[6], sets_summary$bic[7]))

# We would prefer to use a model with minimal cv.error, so we may choose model 7.
# Yet, the predictors Rating, Age and Gender are nor highly significant.
# Especially if there are additional (domain) reasons (e.g. interpretability) to favor smaller models, 
# we might prefer to choose model 4.


############ STEPWISE FORWARD & BACKWARD SELECTION ############

# Stepwise forward selection 
sets_FWS <- regsubsets(Balance ~ ., Cr1, nvmax = 12, method = "forward") # set the parameter method="foreward" 
summary(sets_FWS)

# Stepwise backward selection
sets_BWS <- regsubsets(Balance ~ ., Cr1, nvmax = 12, method = "backward") # set the parameter method="foreward" 
summary(sets_BWS)

# We can now again use Adjusted R^2, Cp, BIC or cross validation to find the best model size.
# Let's only look at the regsubsets-plots and compare both with best subsets:

par(mfrow=c(3,3)) 
# Best Subset
plot(sets, scale="adjr2", title(main="Best Subsets"))
plot(sets, scale="Cp", title(main="Best Subsets"))
plot(sets, scale="bic", title(main="Best Subsets"))
# FWS
plot(sets_FWS, scale="adjr2", title(main="Foreward Stepwise"))
plot(sets_FWS, scale="Cp", title(main="Foreward Stepwise"))
plot(sets_FWS, scale="bic", title(main="Foreward Stepwise"))
# BWS
plot(sets_FWS, scale="adjr2", title(main="Backward Stepwise"))
plot(sets_FWS, scale="Cp", title(main="Backward Stepwise"))
plot(sets_FWS, scale="bic", title(main="Backward Stepwise"))
par(mfrow=c(1,1))


# We see a that the patterns for FWS and BWS are exactly identical.
# They are very similar to teh pattern of Best Subsets.
# For AdjR2 and Cp the winning models (top row) are exactly identical to best subsets.
# For bic, model 5 wins in FWS and BWS, while in Best Subsets model 4 wins.
summary(glm5)

# We could go on now, analysing cv-error etc. ...


############ RIDGE & LASSO REGRESSION ############

# We use the function glmnet() 
# It fits a generalized linear model via penalized maximum likelihood. 
# It can do both, ridge regression and LASSO regression
# For Ridge regression, set the parameter alpha=0 
# For LASSO, set the parameter alpha=1. 
# If we dont give a parameter alpha, glmnet falls back to ordinary least squares.
# gmlnet standardizes the varibales for you (which is good!)
# See help for more detail

# install the package "glmnet" if not already present
# install.packages("glmnet")

# We need the library "glmnet" to use the glmnet() function
library("glmnet")

# First we need to transform our data set so that it fits the input format that glmnet needs.
# glmnet needs as inout a matrix holding all predictor variables and a vector holding the output variable
# The predictor matrix must be a so-called model-matrix:
# It is a transformed version of the data set that looks similar than it would when we would apply a model.
# E.g., a model would transform categorical variables in dummy variables. Model matrix does the same.
# It also removes the response variable.
# To create the model matrix holding the predictor variables, we use the function model.matrix().
# See help for more detail.

predictors <- model.matrix(Balance ~ ., Cr1)[,-1] # we remove the first column, which is the intercept. glmnet doesnt need that
head(predictors) # Just checking how the model matrix looks like
outputs <- Cr1$Balance # creating the vector holding the response variable

############ Ridge Regression ############

m_ridge <- glmnet(predictors, outputs, alpha = 0) # calling ridge regression by using alpha=0

############ Exploring the output a bit ############

dim(coef(m_ridge))
# This gives us 13 rows (12 predictors + 1 intercept) and 100 columns, one for each LAMBDA value 
# (The default number of lambda values is 100.)

m_ridge
# Df ... degrees of freedom. Corresponds to the number of nonzero coefficients 
# %dev ... percentage of the original variability.
# Lambda ...value of lambda. 
#
# We see here, that Ridge Regression never kicks out a coeffizient (Df is always 12).
# We also see that %Dev decreases with increasing lambda. 
# This is logical, since bigger lambda means we need smaller betas to "win", which again means less variability.


# The plot command associated with glmnet() has on the x-axes 
# a metric (the L1-norm) for the aggregated size of the coefficient vector.
# It roughly an inverse metric lambda. 
# On the y-axes you have the single coefficients.
# (So its like reading our lambda-graphs from right to left: 
# the bigger betas are now on the right of teh picture instead of left.) 
plot(m_ridge, label=TRUE) # label=TRUE labels the coefficient curves with variable sequence numbers.
# We see that variable 9 (Student) has the largest beta.

############ Using cross-validation to select the best lambda ############

# We use cv.glmnet(), which does k-fold cross-validation for glmnet. 
# It returns a value for teh best lambda
(cv_ridge <- cv.glmnet(predictors, outputs, alpha = 0) )
# Here, "Lambda min" indicates the value of lambda that gives minimum cv error
# "Lambda 1se" indicates largest value of lambda such that error is within 1 standard error of the minimum.
# We only need teh first.

# We can us plot() to plot the cross-validation errors as a function of lambda.
# It also shows upper and lower standard deviation curves.
# The two vertical dashed lines indicate "Lambda min" and "Lambda 1se"
# Note that the x-axes is logarithmic.
plot(cv_ridge)

# The best lambda is stored in best_ridge$lambda.min
names(cv_ridge)
(best_lambda <- cv_ridge$lambda.min)

# We can retrieve the coefficients of the best model
coef(m_ridge, s=best_lambda)
# Notice that cross validation does not give us a specific model, it only tells us which the best lambda is. 
# Therefore coeff() retrieves the coefficient estimates from m_ridge, where all the 
# fitted models (for the different lambdas) are stored. 

############ Doing predictions with Ridge Regression ############

# We applied cross validation on the whole data set to find the best lambda. 
# Now we want to find a specific model for prediction, and want to be able to test it on new data. 
# Since we didnt hold out a test data set in the beginning, we need to do the fit again, 
# this time only to the training data. We use the lambda from above though.

# We split our original data set in training and test data
set.seed(1)
(train=sample(nrow(Cr1),nrow(Cr1)*0.8)) # indices of a training data (80%)
Cr1.Train <- Cr1[train,] # training data 
Cr1.Test <- Cr1[-train,] # test data

# Train ridge regression on training data
predictors.Train <- model.matrix(Balance ~ ., Cr1.Train)[,-1] # prepare format for glmnet
outputs.Train <- Cr1.Train$Balance  # prepare format for glmnet
m_ridge.Train <- glmnet(predictors.Train, outputs.Train, alpha = 0) # do the fit

# We can use the predict() function to make predictions with ridge regression
predictors.Test <- model.matrix(Balance ~ ., Cr1.Test)[,-1] # prepare format for glmnet
ridge.pred <- predict(m_ridge.Train, newx = predictors.Test, s = best_lambda) # s specifies the lambda to use

# Compute MSE just for fun - maybe to compare later with other models
(MSE_ridge <- mean((Cr1.Test$Balance-ridge.pred)^2)) 



############ Lasso Regression ############

m_LASSO <- glmnet(predictors, outputs, alpha = 1)

dim(coef(m_LASSO))
# We only 71 lines, because glmnet has a stop criterion, see help.

m_LASSO  # We see that some of the coeffizients are set to zero
plot(m_LASSO, label=TRUE)
(cv_LASSO <- cv.glmnet(predictors, outputs, alpha = 1) )
plot(cv_LASSO)
(best_lambda_LASSO <- cv_LASSO$lambda.min) # best lamda is very small, but lambda.1se is considerably bigger
coef(m_LASSO, s=best_lambda_LASSO) # for small lambda almost all coefficients are included
coef(m_LASSO, s=cv_LASSO$lambda.1se) # We can try again with lambda.1se
coef(m_ridge, s=best_lambda) # compare with ridge

# Again, we could do predictions (in the same way than with ridge.)
# We ould prefer LASSO, because it not only decreases variance, but also does subset selection for us.

