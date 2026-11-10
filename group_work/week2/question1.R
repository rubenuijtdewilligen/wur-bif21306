library(car)

data <- read.table("data/raw/county_facts_and_primary_results.txt", header = TRUE)

# Model 1: predict POP2014 based on PERS, MEDINC, HO and AREA
m1 <- lm(POP2014 ~ PERS + MEDINC + HO + AREA, data = data)
summary(m1)
vif(m1)

# Model 2: predict PERS based on POP2014, MEDINC, HO and AREA
m2 <- lm(PERS ~ POP2014 + MEDINC + HO + AREA, data = data)
summary(m2)
vif(m2)

# Residual diagnostics for both models (normality of the residuals)
qqnorm(m1$residuals, main = "Residuals for Model 1 (POP2014)")
qqnorm(m2$residuals, main = "Residuals for Model 2 (PERS)")

# Distribution of the two response variables
hist(data$POP2014, breaks = 80, main = "POP2014", xlab = "Population")
hist(data$PERS, breaks = 40, main = "PERS", xlab = "Persons per household")