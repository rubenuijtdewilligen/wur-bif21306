### Question a
mydata <- read.csv("data/raw/winedata.csv", header=TRUE, row.names=1)

### Question b
dim(mydata)
# there are 40 rows and 8729 columns
colnames(mydata)
# column 1 through 16 are measured concentrations, column 17 is the pH and
# column 18 through 8729 are NMR intensity measurements at specific chemical shifts (ppm)
rownames(mydata)
# the row names are the different samples

### Question c
library(glmnet)

x <- mydata[, -c(1:17)]
y <- mydata[, 1] # malicAcid

### Question d
?cv.glmnet

### Question e
x <- as.matrix(x)
mdlridge <- cv.glmnet(x=x, y=y, alpha=0)
plot(mdlridge)
# the numers at the top of the plot are the amount of explanatory variables
# because we apply Ridge regression, the coefficients get close to 0, but never become 0
# therefore, all 8712 chemical shifts stay part of the model

# the optimal lambda is at the lowest average mean-squared error, which is at log(lambda)=-2.6
# lambda=exp(-2.6)=0.074

### Question f
ypred <- predict(mdlridge, newx=x) # get predictions for x
plot(y, ypred, xlab="Observed malicAcid", ylab="Predicted malicAcid")
abline(a=0, b=1, col="red")
# a dot on the red line would mean a perfectly predicted malicAcid

### Question g
R2ridge <- sum((ypred-mean(y))^2)/sum((y-mean(y))^2)
print(R2ridge)
# 0.6401995

### Question h
# y_ethanol <- mydata[,2]
# mdlridge_ethanol <- cv.glmnet(x=x, y=y_ethanol, alpha=0)
# ypred_ethanol <- predict(mdlridge_ethanol, newx=x) # get predictions for x
# plot(y_ethanol, ypred_ethanol, xlab="Observed ethanol", ylab="Predicted ethanol")
# abline(a=0, b=1, col="green")
# R2ridge_ethanol <- sum((ypred_ethanol-mean(y_ethanol))^2)/sum((y_ethanol-mean(y_ethanol))^2)
# print(R2ridge_ethanol)
# 
# y_lacticAcid <- mydata[,5]
# mdlridge_lacticAcid <- cv.glmnet(x=x, y=y_lacticAcid, alpha=0)
# ypred_lacticAcid <- predict(mdlridge_lacticAcid, newx=x) # get predictions for x
# plot(y_lacticAcid, ypred_lacticAcid, xlab="Observed lacticAcid", ylab="Predicted lacticAcid")
# abline(a=0, b=1, col="blue")
# R2ridge_lacticAcid <- sum((ypred_lacticAcid-mean(y_lacticAcid))^2)/sum((y_lacticAcid-mean(y_lacticAcid))^2)
# print(R2ridge_lacticAcid)

# ethanol
y_eth <- mydata[, 2]
mdl_eth <- cv.glmnet(x = x, y = y_eth, alpha = 0)
ypred_eth <- predict(mdl_eth, newx = x)
R2_eth <- sum((ypred_eth - mean(y_eth))^2) / sum((y_eth - mean(y_eth))^2)

# lacticAcid
y_lac <- mydata[, 5]
mdl_lac <- cv.glmnet(x = x, y = y_lac, alpha = 0)
ypred_lac <- predict(mdl_lac, newx = x)
R2_lac <- sum((ypred_lac - mean(y_lac))^2) / sum((y_lac - mean(y_lac))^2)

# glucose
y_glu <- mydata[, 7]
mdl_glu <- cv.glmnet(x = x, y = y_glu, alpha = 0)
ypred_glu <- predict(mdl_glu, newx = x)
R2_glu <- sum((ypred_glu - mean(y_glu))^2) / sum((y_glu - mean(y_glu))^2)

# compare R^2
c(ethanol = R2_eth, lacticAcid = R2_lac, GlucFruct = R2_glu)

# visualize in plots
par(mfrow = c(1, 3))
plot(y_eth, ypred_eth, main = sprintf("ethanol (R^2 = %.2f)", R2_eth), xlab = "Observed", ylab = "Predicted")
abline(0, 1, col = "red")

plot(y_lac, ypred_lac, main = sprintf("lacticAcid (R^2 = %.2f)", R2_lac), xlab = "Observed", ylab = "Predicted")
abline(0, 1, col = "red")

plot(y_glu, ypred_glu, main = sprintf("glucose (R^2 = %.2f)", R2_glu), xlab = "Observed", ylab = "Predicted")
abline(0, 1, col = "red")
par(mfrow = c(1, 1))

# lacticAcid gets the highest R^2, and its points fit the red line the best

### Question i
mdllasso <- cv.glmnet(x=x, y=y, alpha=1)
plot(mdllasso)
ypred2 <- predict(mdllasso, newx=x)
R2lasso <- sum((ypred2-mean(y))^2)/sum((y-mean(y))^2)
plot(y, ypred2, main=sprintf('%s lasso Rˆ2=%.2f', colnames(mydata)[1], R2lasso))
abline(a=0, b=1, col = "red")
# in the cross validation plot, for a higher log(lambda), the number of active predictors drops from thousands to a few
# in the scatter plot, the lasso model maintains high predictive fit while not using that many of the available predictors

### Question j
idx <- which(coef(mdllasso) != 0)
length(colnames(x)[idx])
# 14 are selected
rownames(coef(mdllasso))[idx] # and their names are
# [1] "(Intercept)"       "X5.29012029279206" "X4.39988315794268" "X4.38599293314362" "X4.36831446521753"
# [6] "X4.36705171750852" "X3.45092825462452" "X3.43261841284393" "X2.89973887964331" "X2.89910750578881"
# [11] "X2.85743683139161" "X2.84733484971956" "X2.75957388394363" "X1.30678264473199"

### Question k
# both models achieve a similar R^2 but Lasso delivers better interpretability because the few
# explanatory variables immediately point to the specific ppm zones we are interested in

### Question l
plot(mdllasso) # plot the cv plot again
# give the log of lambda.min and lambda.1se as the plot uses log(lambda)
log(mdllasso$lambda.min) # -3.158
log(mdllasso$lambda.1se) # -2.274
# the next command will give a summary of all models created during the cross
# validation. look up the lines where lambda equal lambda.min en lambda.1se
mdllasso$lambda.min # 0.0425
mdllasso$lambda.1se # 0.1029
mdllasso$glmnet.fit # lambda.min corresponds with 61 and lambda.1se corresponds with 42
# the number df shows the amount of predictors in the model

# lambda.min is the smallest and lambda.1se is the largest of the two. this happens because a larger
# lambda means a higher L1 penalty on the coefficients, so more coefficients will be put to 0

### Question m
splits <- split(sample(1:nrow(mydata)), 1:10) # 10 random groups
ypred <- rep(NA, nrow(mydata)) # vector for the predicted values

# leave out one group and make a model
for (i in splits) {
  mdl <- cv.glmnet(x=x[-i,], y=y[-i], alpha=1)
  # predict the left out group
  ypred[i] <- predict(mdl, newx=x[i,, drop=FALSE])
}

### Question n
Q2 <- sum((ypred - mean(y))^2) / sum((y - mean(y))^2)
plot(y, ypred, main = sprintf("%s lasso Q^2=%.2f", colnames(mydata)[1], Q2),
     xlab = "Observed malicAcid", ylab = "Predicted malicAcid")
abline(a = 0, b = 1, col = "red")

# Q^2 is lower than the in-sample R^2 from question i
# R^2 evaluates predictions on the exact data used for model training
# this is prone to overfitting / optimism bias
# Q^2 evaluates out-of-fold generalization performance on unseen validation groups,
# this gives a realistic measure of true predictive power

### Question o
n_repeats <- 5

Q2_runs <- replicate(n_repeats, {
  splits <- split(sample(1:nrow(mydata)), 1:10)
  ypred_run <- rep(NA, nrow(mydata))
  
  for (i in splits) {
    mdl <- cv.glmnet(x = x[-i, ], y = y[-i], alpha = 1)
    ypred_run[i] <- predict(mdl, newx = x[i, , drop = FALSE])
  }
  
  sum((ypred_run - mean(y))^2) / sum((y - mean(y))^2)
})

print(Q2_runs)
# 0.6118256 0.8020700 0.5749362 0.6938513 0.7705314
print(mean(Q2_runs))
# 0.69

# the Q^2 values fluctuate around 0.7, from 0.57 to 0.80
# this happens because the dataset is small. the random assignment of the 10 folds
# have a relatively high influence. it is therefore better to use repeated cross-validation.