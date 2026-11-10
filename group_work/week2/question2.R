library(glmnet)

data <- read.table("data/raw/county_facts_and_primary_results.txt", header = TRUE)

# x = predictors, y = response
socioeconomic <- data[, c(2:52)]
fracvotes_clinton <- data$Democrat_Hillary_Clinton_fracvotes

# Cross-validation plot
set.seed(123)
cv_c <- cv.glmnet(x = as.matrix(socioeconomic), y = fracvotes_clinton, alpha = 1)
plot(cv_c)

# Get lambdas
cv_c$lambda.min # smallest cross-validated error
cv_c$lambda.1se # simplest model within 1 SE of that error

# Get relevant predictors
idx_c <- which(coef(cv_c, s = "lambda.min") != 0)
rownames(coef(cv_c, s = "lambda.min"))[idx_c]
sort(coef(cv_c, s = "lambda.min")[idx_c, 1]) # sort by effect size to see which matter most

# Validate
set.seed(123)
splits <- split(sample(1:length(fracvotes_clinton)), 1:10) # 10 random groups
ypred_c <- rep(NA, length(fracvotes_clinton)) # vector for the predicted values

x <- as.matrix(socioeconomic)

for (i in splits) {
  mdl <- cv.glmnet(x = x[-i, ], y = fracvotes_clinton[-i], alpha = 1)
  ypred_c[i] <- predict(mdl, newx = x[i, , drop = FALSE])
}

Q2_c <- 1 - sum((fracvotes_clinton - ypred_c)^2) / sum((fracvotes_clinton - mean(fracvotes_clinton))^2)
plot(fracvotes_clinton, ypred_c, main = sprintf("Clinton Q^2 = %.2f", Q2_c),
     xlab = "Observed", ylab = "Predicted")
abline(a = 0, b = 1, col = "red")

# Do the same for Trump
fracvotes_trump <- data$Republican_Donald_Trump_fracvotes

# Trump's cross-validation plot
set.seed(123)
cv_c <- cv.glmnet(x = as.matrix(socioeconomic), y = fracvotes_trump, alpha = 1)
plot(cv_c)

# Trump's lambdas
cv_c$lambda.min # smallest cross-validated error
cv_c$lambda.1se # simplest model within 1 SE of that error

# Trump's relevant predictors
idx_c <- which(coef(cv_c, s = "lambda.min") != 0)
rownames(coef(cv_c, s = "lambda.min"))[idx_c]
sort(coef(cv_c, s = "lambda.min")[idx_c, 1]) # sort by effect size to see which matter most

# Trump's validation
set.seed(123)
splits <- split(sample(1:length(fracvotes_trump)), 1:10) # 10 random groups
ypred_c <- rep(NA, length(fracvotes_trump)) # vector for the predicted values

x <- as.matrix(socioeconomic)

for (i in splits) {
  mdl <- cv.glmnet(x = x[-i, ], y = fracvotes_trump[-i], alpha = 1)
  ypred_c[i] <- predict(mdl, newx = x[i, , drop = FALSE])
}

Q2_t <- 1 - sum((fracvotes_trump - ypred_c)^2) / sum((fracvotes_trump - mean(fracvotes_trump))^2)
plot(fracvotes_trump, ypred_c, main = sprintf("Trump Q^2 = %.2f", Q2_t),
     xlab = "Observed", ylab = "Predicted")
abline(a = 0, b = 1, col = "red")
