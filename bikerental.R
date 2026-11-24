library(ggplot2)
library(chemometrics)
library(class)
library(tree)
library(randomForest)

## Question a
bike_share_data <- read.csv("data/raw/bike_share_data.csv", stringsAsFactors = TRUE)
head(bike_share_data)
summary(bike_share_data)

## Question b
ggplot(bike_share_data, aes(x = weather)) +
  geom_bar() +
  labs(title = "Frequency of weather classes", x = "Weather", y = "Count")
# 2/3 is sunny, so this is quite easy to predict right. it is harder to predict
# cloudy right.

## Question c
ggplot(bike_share_data, aes(x = weather, y = casual_1h, fill = weather)) +
  geom_boxplot() +
  labs(title = "Distribution of casual bike rentals by weather type",
       x = "Weather", y = "Casual rentals (last hour)")
# the data is strongly right-skewed: for most hours, there were close to 0
# casual rentals. also, there were more rentals when it was sunny, but not
# a lot more. casual_1h contains useful data, but not to predict weather.

## Question d
ndata <- bike_share_data
ndata[,3:15] <- scale(bike_share_data[,3:15])
ntrain <- round(nrow(ndata)*0.75)
train <- sample(1:nrow(ndata), ntrain)
training <- ndata[train,]
testing <- ndata[-train,]

knnEval(ndata[,3:15], ndata[,2], train, kfold=10,
        knnvec=seq(1,20,1), legpos="bottomright")
# The optimal number of neighbors is k = 17.

pred_knn <- knn(training[,3:15], testing[,3:15], training[,2], k=17)
cm <- table(testing[, 2], pred_knn)
cm
#              pred_knn
#               cloudy partly_cloudy sunny
# cloudy            51            60    83
# partly_cloudy     23           181   511
# sunny              6            97  1709

length(which(pred_knn == testing[, 2])) / length(pred_knn)
# Total accuracy: 71.3%
diag(cm) / rowSums(cm)
#    cloudy partly_cloudy         sunny 
# 0.2628866     0.2531469     0.9431567 
# 'sunny' is predicted best (94.3%) while 'cloudy' (26.3%) and 'partly_cloudy' (25.3%)
# are predicted poorly. This happens because 66% of the dataset is sunny.

## Question e
pred_knn_weather <- knn(training[,c(3:10, 13)], testing[,c(3:10, 13)], training[,2], k=17)
cm_weather <- table(testing[, 2], pred_knn_weather)
cm_weather
#             pred_knn_weather
#               cloudy partly_cloudy sunny
# cloudy            48            68    78
# partly_cloudy     25           188   502
# sunny              7           120  1685

length(which(pred_knn_weather == testing[, 2])) / length(pred_knn_weather)
# Total accuracy: 70.6%
diag(cm_weather) / rowSums(cm_weather)
#    cloudy partly_cloudy         sunny 
# 0.2474227     0.2629371     0.9299117
# Performance is almost idential without the bike rental variables (70.6% vs 71.3%).
# This shows that almost all predictive power comes from the weather variables.

## Question f
pred_knn_rental <- knn(training[,c(11, 12, 14, 15)], testing[,c(11, 12, 14, 15)], training[,2], k=17)
cm_rental <- table(testing[, 2], pred_knn_rental)
cm_rental
#              pred_knn_rental
#               cloudy partly_cloudy sunny
# cloudy             0            12   182
# partly_cloudy      2            34   679
# sunny              3            81  1728

length(which(pred_knn_rental == testing[, 2])) / length(pred_knn_rental)
# Total accuracy: 64.8%
diag(cm_rental) / rowSums(cm_rental)
#     cloudy partly_cloudy         sunny 
# 0.00000000    0.04755245    0.95364238 
# Using only bike rental variables drops accuracy to 64.8%, which is worse than
# the 66% of always guessing 'sunny'. 0% of 'cloudy' hours are predicted right.
# Bike rental counts alone are insufficient to predict the weather.

## Question g
rf_all <- randomForest(weather ~ ., data = training[, 2:15])
pred_rf_all <- predict(rf_all, newdata = testing[, 2:15])

cm_rf_all <- table(testing[, 2], pred_rf_all)
cm_rf_all
#              pred_rf_all
#               cloudy partly_cloudy sunny
# cloudy            61            64    69
# partly_cloudy     23           207   485
# sunny              7           114  1691
length(which(pred_rf_all == testing[, 2])) / length(pred_rf_all)
# Total accuracy: 72.0%
diag(cm_rf_all) / rowSums(cm_rf_all)
#    cloudy partly_cloudy         sunny 
# 0.3144330     0.2895105     0.9332230 

rf_no_rental <- randomForest(weather ~ ., data = training[, c(2:10, 13)])
pred_rf_no_rental <- predict(rf_no_rental, newdata = testing[, c(2:10, 13)])

cm_rf_no_rental <- table(testing[, 2], pred_rf_no_rental)
cm_rf_no_rental
length(which(pred_rf_no_rental == testing[, 2])) / length(pred_rf_no_rental)
# Total accuracy: 73.7%
diag(cm_rf_no_rental) / rowSums(cm_rf_no_rental)
#    cloudy partly_cloudy         sunny 
# 0.2678571     0.3966049     0.9156301

# Random Forest performs slight better than k-NN (72-73.7% vs 70.6-71.3%).
# This is especially clear on 'partly_cloudy' (up to 39.7%).
# Removing the bike rental variables improves total accuracy from 72.0% to 73.7%,
# indicating that bike rental counts mostly add noise (e.g. weekend patterns).