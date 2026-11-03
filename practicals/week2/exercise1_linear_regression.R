### Question a
theData <- read.csv(file = "data/raw/lser.csv", header = TRUE)

### Question b
pairs(theData)
cor(theData)
# color shows some negative correlation with tox (-0.44)
# the same goes for base (-0.56) and acid (-0.49)
# bsae and acid are somewhat positively correlated (0.56)
# color has no correlation with base (0.09) and acid(-0.04)

### Question c
model <- lm(tox ~ color + base + acid, data = theData)
summary(model)
#               Estimate  P    
# (Intercept)   3.9198    3.84e-07
# color         -2.0065   0.0139  
# base          -1.3378   0.0742 .  
# acid          -0.8616   0.1211  
# Multiple R-squared: 0.5284, Adjusted R-squared: 0.4577

# interpretation:
# - the expected toxicity when color, base, and acid are all 0
# - an increase of 1 unit in color decreases the expected toxicity by 2.01 while base and acid stay constant
# - an increase of 1 unit in base decreases the expected toxicity by 1.34 while color and acid stay constant
# - an increase of 1 unit in acid decreases the expected toxicity by 0.86 while color and base stay constant

# color is statistically significant so it might be an important predictor

### Question d
predict(model, data.frame(color = 0.52, base = 0.60, acid = 0.95))
# predicted tox = 1.2553

### Question e
library(car)
vif(model)
#    color     base     acid 
# 1.018984 1.491267 1.481423
# all VIF < 10, so multicollinearity is not a problem in this model

### Question f
ypred <- predict(model)
plot(theData$tox, ypred, xlab = "Observed toxicity", ylab = "Predicted toxicity")
abline(a = 0, b = 1, col = "red")
# if all points are on the red line, the predictions are perfect
# points follow the line reasonably well, but do show scatter
# the model is right about general trends (R^2 = 0.53), but individual sample predictions are not so good