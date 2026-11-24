source("http://www.bioinformatics.nl/bda/plot_classifier.R")
library(ggplot2)
library(chemometrics)
library(class)
library(tree)
library(randomForest)

### --- k-nearest neighbour classification ---

## Question a
simple <- read.table(url("http://www.bioinformatics.nl/bda/simple.txt"),
                     sep="\t",header=FALSE, stringsAsFactors=TRUE)
dim(simple)
# 100 samples with 2 features and a class

## Question b
plot_classifier(simple, "knn", 1)
# k=1 and k=2 give similar results that seem to be the best
# this happens because this data is very nicely split up at x1=2.5

## Question c
ntrain <- round(nrow(simple)*3/4)
train <- sample(1:nrow(simple), ntrain)
res <- knnEval(simple[,1:2],simple[,3],train,kfold=10,
               knnvec=seq(1,25,1),legpos="bottomright")
# to find the optimal k, we look at CV error = 0
# k=1 or k=3 or any k=5 to 15 is optimal. to avoid overfitting, we choose k=5

## Question d
hard <- read.table(url("http://www.bioinformatics.nl/bda/hard.txt"),
                     sep="\t",header=FALSE, stringsAsFactors=TRUE)
ntrain_hard <- round(nrow(hard)*3/4)
train_hard <- sample(1:nrow(hard), ntrain_hard)
res_hard <- knnEval(hard[,1:2],hard[,3],train_hard,kfold=10,
               knnvec=seq(1,25,1),legpos="bottomright")
# for hard, the optimal k = 3

banana <- read.table(url("http://www.bioinformatics.nl/bda/banana.txt"),
                   sep="\t",header=FALSE, stringsAsFactors=TRUE)
ntrain_banana <- round(nrow(banana)*3/4)
train_banana <- sample(1:nrow(banana), ntrain_banana)
res_banana <- knnEval(banana[,1:2],banana[,3],train_banana,kfold=10,
                    knnvec=seq(1,25,1),legpos="bottomright")
# for banana, the optimal k = 3

spirals <- read.table(url("http://www.bioinformatics.nl/bda/spirals.txt"),
                     sep="\t",header=FALSE, stringsAsFactors=TRUE)
ntrain_spirals <- round(nrow(spirals)*3/4)
train_spirals <- sample(1:nrow(spirals), ntrain_spirals)
res_spirals <- knnEval(spirals[,1:2],spirals[,3],train_spirals,kfold=10,
                      knnvec=seq(1,25,1),legpos="bottomright")
# for spirals, the optimal k = 1

## Question e
nhard <- hard; nhard[,1:2] <- scale(hard[,1:2])

plot_classifier(hard, "knn", 3)
plot_classifier(nhard, "knn", 3)
# yes, scaling has a clear influence on the decision boundary.
# in the unscaled dataset, the two features have very different ranges
# because k-NN uses Euclidean distance, the feature with the largest scale dominates
# after scaling, both features contribute equally

## Question f
res_nhard <- knnEval(nhard[,1:2],nhard[,3],train_hard,kfold=10,
                    knnvec=seq(1,25,1),legpos="bottomright")
# the optimal k for the scaled data is k=13

training <- nhard[train_hard,]
testing  <- nhard[-train_hard,]

preds_train <- knn(training[,1:2], training[,1:2], training[,3], k=13)
table(training[,3], preds_train)
length(which(preds_train == training[,3])) / length(preds_train)

preds_test <- knn(training[,1:2], testing[,1:2], training[,3], k=13)
table(testing[,3], preds_test)
length(which(preds_test == testing[,3])) / length(preds_test)

### --- Other classifiers ---

## Question a
plot_classifier(simple, "lr")
# the straight line at around x=2.7 splits the data perfectly

## Question b
plot_classifier(hard, "lr")
plot_classifier(banana, "lr")
plot_classifier(spirals, "lr")
# for hard, it is still quite ok, but for banana and spirals it fails completely

## Question c
# Decision tree
plot_classifier(simple, "tree")
plot_classifier(hard, "tree")
plot_classifier(banana, "tree")
plot_classifier(spirals, "tree")
# shows straight lines or stair shapes because it splits for one variable each
# time (e.g. x1>2.5 or x2<1). works ok for banana, but fails for spirals

# Random forest
plot_classifier(simple, "forest")
plot_classifier(hard, "forest")
plot_classifier(banana, "forest")
plot_classifier(spirals, "forest")
# combines many trees, resulting in smoother and more flexible boundaries
# that capture non-linear patterns much better

### --- Multiple classifiers ---

## Question a
data("iris")
ntrain <- 100
train <- sample(1:nrow(iris), ntrain)
training <- iris[train,]
testing <- iris[-train,]

pred_knn <- knn(training[, -5], testing[, -5], training[, 5], k=1)
table(testing[, 5], pred_knn)

iris_tree <- tree(Species ~ ., data = training)
plot(iris_tree); text(iris_tree)
pred_tree <- predict(iris_tree, newdata=testing, type="class")
table(testing[, 5], pred_tree)
#           pred_tree
#            setosa versicolor virginica
# setosa         16          0         0
# versicolor      0         18         3
# virginica       0          1        12

iris_rf <- randomForest(Species ~ ., data = training)
pred_rf <- predict(iris_rf, newdata=testing, type="class")
table(testing[, 5], pred_rf)
#           pred_rf
#            setosa versicolor virginica
# setosa         16          0         0
# versicolor      0         19         2
# virginica       0          1        12
# The results match the expectations. Setosa is 100% linearly seperable and
# always predicted correctly, while versicolor and virginica overlap.

## Question b
cv.results <- cv.tree(iris_tree, FUN = prune.misclass)
plot(cv.results$size, cv.results$dev, type = "b")
# The unpruned tree makes redundant splits at the bottom

# choose the smallest tree size ('best') with the smallest deviance (size = 3)
pruned.tree <- prune.misclass(iris_tree, best = 3)
plot(pruned.tree); text(pruned.tree)
# After pruning to size = 3, the redundant split is gone and the tree is much cleaner.