# Get dataset
library(faraway)
data(prostate)
mydata <- prostate[, c(9, 1:8)]

# Scatterplot slide 14
pairs(mydata)

# Correlation matrix slide 15
cor(mydata)

# Correlation test lpsa and lcavol, slide 15
cor.test(mydata$lpsa, mydata$lcavol)

# 'new' is lcavol with a little noise, which is strongly correlated
mydata$new <- mydata$lcavol + rnorm(nrow(mydata), mean=0, sd=0.1)

# MLR summary slide 24
mymodel <- lm(lpsa ~ lcavol + new, data = mydata)
summary(mymodel)

# Detecting multicollinearity, indicated by VIF > 10, slide 26
vif(mymodel)