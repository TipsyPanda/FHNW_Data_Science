
sets <- regsubsets(int_rate~  purpose +term + dti+loan_amnt + emp_length, LCtrain, nvmax = 17) 
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

steps <- 1:17 # First we need to define the x-axes (holdimg the number of predictors). For this we construct the vector 1,2,3,...,12

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
glm1 <- glm(int_rate ~ purpose, data=LCtrain) 
glm2 <- glm(int_rate ~ purpose + term, data=LCtrain) 
glm3 <- glm(int_rate ~ purpose + term + dti, data=LCtrain) 
glm4 <- glm(int_rate ~ purpose + term + dti + emp_length, data=LCtrain) 
glm5 <- glm(int_rate ~ purpose + term + dti + emp_length + loan_amnt , data = LCtrain)

# We do 10-fold CV
library(boot) # load library boot to use cv.glm
set.seed(1)
cv.err.glm1 <- cv.glm(LCtrain, glm1, K = 10) 
cv.err.glm2 <- cv.glm(LCtrain, glm2, K = 10) 
cv.err.glm3 <- cv.glm(LCtrain, glm3, K = 10) 
cv.err.glm4 <- cv.glm(LCtrain, glm4, K = 10) 
cv.err.glm5 <- cv.glm(LCtrain, glm5, K = 10)


# We plot the CV error as a function of the number of predicors
x <- 1:5 # define the x-axes (number of predictors)
(cv.err <- c(cv.err.glm1$delta[1], cv.err.glm2$delta[1], cv.err.glm3$delta[1], cv.err.glm4$delta[1], cv.err.glm5$delta[1]))
plot(cv.err ~x)
lines(cv.err ~x)
# Here it's hard again to see which model wins. 

# To see it more clearly, we find the minimum:
(cv.min <- which.min(cv.err))
cv.err[cv.min]

# Which model is it?
coef(sets,5)
# Inspect the coefficient estimates
summary(glm5)
# Rating, Age and Gender are significant, but much less than the other predictors.

# Compare it with the other winning models of the last subsection
coef(sets,4)
summary(glm4)

# We see that Gender was added as a predictor
coef(sets,3)
summary(glm4)

# Compare all 4 metrics (AdjR2, Cp, BIC, Ccv-error) of all 3 models
data.frame("predictors"= c(5,4,3), 
           "cv-err"=c(cv.err.glm5$delta[1], cv.err.glm4$delta[1], cv.err.glm3$delta[1]),
           "adjR2"=c(sets_summary$adjr2[5], sets_summary$adjr2[4], sets_summary$adjr2[3]),
           "Cp"=c(sets_summary$cp[5], sets_summary$cp[4], sets_summary$cp[3]),
           "BIC"=c(sets_summary$bic[5], sets_summary$bic[4], sets_summary$bic[3]))

# We would prefer to use a model with minimal cv.error, so we may choose model 7.
# Yet, the predictors Rating, Age and Gender are nor highly significant.
# Especially if there are additional (domain) reasons (e.g. interpretability) to favor smaller models, 
# we might prefer to choose model 4.
