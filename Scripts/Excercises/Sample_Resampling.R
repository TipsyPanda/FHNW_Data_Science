#####################################################
# Data Science - Exercise
# Resampling Methods
# Gwendolin Wilke
# gwendolin.wilke@fhnw.ch
#####################################################
# Adapted from ISLR chapter 5 of
# Introduction to Statistical Learning, 
# by Witten, Hastie Tibshirani, Springer 2017
#####################################################



##############   The Validation Set Approach   ##########################

library(ISLR)

## The Auto data set is contained in ISLR package

str(Auto) # inspect it
attach(Auto) # when a dataset is attached, its objects can be accessed by simply giving their names.


## Define training and test data

set.seed(1)
(train=sample(nrow(Auto),nrow(Auto)/2)) # generate indices of a training data set by random sampling half of the observation indices of Auto 
AutoTrain <- Auto[train,] # training data 
AutoTest <- Auto[-train,] # test data

## Fit 3 different regression models to the training data: Which model gives a better fit?

(lm.fit = lm(mpg~horsepower,data=AutoTrain)) # linear regression
(lm.fit2 = lm(mpg~poly(horsepower,2),data=AutoTrain)) # quadratic regression
(lm.fit3=lm(mpg~poly(horsepower,3),data=Auto,subset=train)) # cubic regression

## Plot the fits

plot(mpg~horsepower,data=AutoTrain) # training data

abline(lm.fit$coefficients, col="blue4") # plot linear fit
lines(x, y1) # quadratic fit

# We want to plot the higher order fits.
# Since we dont have a ablines available here, we use predictions of made-up x-avlues to plot the fitting polynomial

y2 <- predict(lm.fit2, newdata = data.frame(horsepower = x)) # corresponding predicted values
lines(x, y2, col = "red4") # quadratic fit

y3 <- predict(lm.fit3, newdata = data.frame(horsepower = x)) # corresponding predicted values
lines(x, y3, col = "green4") # cubic fit


## Calculate the test MSEs of the 3 models (mean of squared errors on test set)

(MSE <- mean((mpg-predict(lm.fit,Auto))[-train]^2)) 
(MSE2 <- mean((mpg-predict(lm.fit2,Auto))[-train]^2)) 
(MSE3 <- mean((mpg-predict(lm.fit3,Auto))[-train]^2))


## Train & evaluate the 3 models on a different training data set (i.e., set a different seed)

set.seed(2)
(train=sample(nrow(Auto),nrow(Auto)/2)) # generate indices of a training data set by random sampling half of the observation indices of Auto 
AutoTrain <- Auto[train,] # training data 
AutoTest <- Auto[-train,] # test data

(lm.fit = lm(mpg~horsepower,data=AutoTrain)) # linear regression
(lm.fit2 = lm(mpg~poly(horsepower,2),data=AutoTrain)) # quadratic regression
(lm.fit3=lm(mpg~poly(horsepower,3),data=Auto,subset=train)) # cubic regression

(MSE <- mean((mpg-predict(lm.fit,Auto))[-train]^2)) 
(MSE2 <- mean((mpg-predict(lm.fit2,Auto))[-train]^2)) 
(MSE3 <- mean((mpg-predict(lm.fit3,Auto))[-train]^2))



# Now lets draw a nice graph that compares the results with different training data sets

# Draw graph for 1 training sample

MSE <- rep(0,10) # initialising the MSE vector (we will need it below when we add )

set.seed(1) # initialize the randomizer with a different number
train <- sample(nrow(Auto),nrow(Auto)/2) # generate indices of a training data set by random sampling half of the observation indices of Auto 
AutoTrain <- Auto[train,] # training data 
AutoTest <- Auto[-train,] # test data
for (i in 1:10){
  lm.fit=lm(mpg~poly(horsepower,i),data=AutoTrain)
  MSE[i] <- mean((mpg-predict(lm.fit,Auto))[-train]^2)
}

x <- seq(1,10,1)
plot(MSE~x, col=rainbow(1)[1], ylim=c(-2,30))
lines(MSE~x, col=rainbow(1)[1])

# Add graphs for different training samples
for (j in 2:10){
  set.seed(j) # initialize the randomizer with different numbers
  train <- sample(nrow(Auto),nrow(Auto)/2) # generate indices of a training data set by random sampling half of the observation indices of Auto 
  AutoTrain <- Auto[train,] # training data 
  AutoTest <- Auto[-train,] # test data
  for (i in 1:10){
    lm.fit=lm(mpg~poly(horsepower,i),data=AutoTrain)
    MSE[i] <- mean((mpg-predict(lm.fit,Auto))[-train]^2)
  }
  
  points(MSE~x, col=rainbow(j)[j]) # add to the previous plot
  lines(MSE~x, col=rainbow(j)[j])
  
}

##############   Leave-One-Out Cross-Validation   ##########################


glm.fit=glm(mpg~horsepower,data=Auto)
coef(glm.fit)

lm.fit=lm(mpg~horsepower,data=Auto)
coef(lm.fit)

library(boot)

# Without specifying "family" as a parameter, glm() falls back to linear regression.
# We use it here, because it comes with a function for cross validation
glm.fit=glm(mpg~horsepower,data=Auto) 

cv.err=cv.glm(Auto,glm.fit) # computing the LOOCV prediction Error. If dont set the parameter K, cv.glm defaults to LOOCV
cv.err$delta[1] # The estimate for the test error is stored in delta[1]. 

# Now we calculate the LOOC test error for polynomial regression models of degree 1,...,10. 
# It takes a bit to evaluate...

cv.error=rep(0,10) # initialising the LOOCV error vector
for (i in 1:10){
  glm.fit=glm(mpg~poly(horsepower,i),data=Auto)
  cv.error[i]=cv.glm(Auto,glm.fit)$delta[1]
}
cv.error

# Plot the results
x <- seq(1,10,1) 
plot(cv.error~x, col="blue3")
lines(cv.error~x, col="blue3")


##############   k-Fold Cross-Validation   ##########################


set.seed(1)

# Now we calculate the k-fold CV test error for polynomial regression models of degree 1,...,10. 
# Notice that the computation time is much shorter than that of LOOCV.

cv.error.10=rep(0,10)
for (i in 1:10){
  glm.fit=glm(mpg~poly(horsepower,i),data=Auto)
  cv.error.10[i]=cv.glm(Auto,glm.fit,K=10)$delta[1] # Setting K=10 means 10-fold CV
}
cv.error.10

# Plot the results
x <- seq(1,10,1) 
plot(cv.error.10~x, col=rainbow(1)[1], ylim=c(-2,30))
lines(cv.error.10~x, col=rainbow(1)[1])


# Add graphs for different training samples
for (j in 2:5){
  set.seed(j) # initialize the randomizer with different numbers
  for (i in 1:10){
    glm.fit=glm(mpg~poly(horsepower,i),data=Auto)
    cv.error.10[i]=cv.glm(Auto,glm.fit,K=10)$delta[1] # Setting K=10 means 10-fold CV
  }
  
  points(cv.error.10~x, col=rainbow(j)[j])
  lines(cv.error.10~x, col=rainbow(j)[j])
}

##############   The Bootstrap   ##########################


alpha.fn=function(data,index){
  X=data$X[index]
  Y=data$Y[index]
  return((var(Y)-cov(X,Y))/(var(X)+var(Y)-2*cov(X,Y)))
}
alpha.fn(Portfolio,1:100)
set.seed(1)
alpha.fn(Portfolio,sample(100,100,replace=T))
boot(Portfolio,alpha.fn,R=1000)

}
