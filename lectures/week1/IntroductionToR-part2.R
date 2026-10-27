a <- 1
b <- 2

# Conditional operators
a < b # [1] TRUE
a <= b # [1] TRUE
a > b # [1] FALSE
a >= b # [1] FALSE
a == b # [1] FALSE
a != b # [1] TRUE

# Conditional operations
# when we want to do something depending on a certain outcome
if (a < b) {
  print("a is smaller than b")
} else {
  if (a > b) {
    print("a is larger than b")
  } else {
    print("a and b are equal")
  }
}
# [1] "a is smaller than b"

# combine with logical OR and AND operators
if (a == 1 & b == 10) {
  print(" a is equal to 1 AND b is equal to 10")
} else {
  if (a == 1 | b == 10) {
    print(" a is equal to 1 OR b is equal to 10")
  } else {
    print(" a is not equal to 1 AND b is not equal to 10")
  }
}
# [1] " a is equal to 1 OR b is equal to 10"

# While loops
# this adds a random number to sum until its value is larger than 10
sum <- 0
count <- 0
while (sum < 10) {
  count <- count + 1
  sum <- sum + runif(1, 0, 1)
}
# the sum became
print(sum)
# [1] 10.38773
# which took 25 runs
print(count)
# [1] 25

# For loops
vec1 <- rnorm(10)
vec2 <- numeric(10)
vec1
# [1]  0.05391842 -1.25798628 -0.09977247  0.23204376  0.22127451
# [6]  0.67293967  0.11911502  0.38175245  0.85672317 -0.21050192
vec2
# [1] 0 0 0 0 0 0 0 0 0 0

for (i in 1:length(vec1)) {
  vec2[i] <- abs(vec1[i])
}
vec2
# [1]  0.05391842 1.25798628 0.09977247 0.23204376 0.22127451
# [6]  0.67293967 0.11911502 0.38175245 0.85672317 0.21050192

# probably don't use this, because
# 1. for-loops are not very efficient
# 2. the function abs() just takes vectors on its own
# 3. use apply:

# Apply statement
mat <- matrix(rnorm(12), ncol=6)
mat
# [,1]      [,2]      [,3]      [,4]       [,5]       [,6]
# [1,] -0.9131008 0.1839773 0.9529390 -1.085225 -0.3091558 -0.2836499
# [2,]  0.4376866 1.7075856 0.1514961  1.668888  1.7989163  0.2780654
uglyCS <- numeric(ncol(mat))
for (col in 1:ncol(mat)) {
  uglyCS[col] <- sum(mat[,col])
}
uglyCS
# [1] -0.475414286  1.891562915  1.104435079  0.583662482  1.489760442 -0.005584488

elegantCS <- apply(mat, 2, sum)
elegantCS
# [1] -0.475414286  1.891562915  1.104435079  0.583662482  1.489760442 -0.005584488
identical(uglyCS, elegantCS)
# [1] TRUE

# There are variants of the apply function.  They all apply some function FUN on every element of a variable.
?lapply
?sapply

# Functions are also objects:
# myfunction <- function(arg1, arg2, ...) {
#   statements
#   return(object)
# }
fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C) # only one object can be returned
}
fahrenheit_to_celsius(100)

### BASE GRAPHICS
library(car)
plot(x=cars$speed, y=cars$dist)

# Formula notation
plot(dist ~ speed, data=cars)
class(dist ~ speed) # [1] "formula"

# Modifying plots
plot(1:10, 1:10, type="b", col="blue", ylim=c(1,100))
text(1:10, 5+(1:10), letters[11:20] )
points(1:10, (1:10)^2, type="b", col="red")
text(1:10, 5+(1:10)^2, letters[1:10] )
legend("topleft", col=c("blue", "red"), legend=c("Linear","Quadratic"), lty=1)

# Bar plots
(cylinders <- table(mtcars$cyl))
#  4  6  8
# 11  7 14
barplot(cylinders)

# Stacked bar plots
(cylinders <- table(mtcars$am, mtcars$cyl))
#    4  6  8
# 0  3  4 12
# 1  8  3  2
barplot(cylinders)

# Pie charts
pie(table(mtcars$cyl))
pie(table(mtcars$am))
# (never used in a professional setting)

# Histograms
# bar plots/pie charts are for counting, histograms are for showing distribution
hist(mtcars$hp)

# Box plots
# visual representation of distribution / 5 number summary
boxplot(mpg ~ am, data=mtcars)
# never put emphasis on 'outliers' from a boxplot. it just shows you whether your data is left-skewed or right-skewed.
# useful, but not for large amounts of data

# Combining plots
par(mfrow=c(1,3)) # 1 row, 3 columns
plot(dist ~ speed, data=cars)
boxplot(mpg ~ am, data=mtcars)
barplot(cylinders)

# Saving graphics
pdf(file = "data/processed/lectures/Myfile.pdf", width=20, height=10) # size in inches
boxplot(dist~speed, data=cars)
graphics.off()
file.exists("data/processed/lectures/Myfile.pdf") # [1] TRUE

### USING ggplot2
# we will use the mtcars data for this
mtcars
#                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
# Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2

library(ggplot2)

p <- ggplot(data=mtcars, x=hp, y=qsec)
p # no output

# we need to add a layer
p <- ggplot(data=mtcars, aes(x=hp, y=qsec))
p1 <- p + geom_point()
p1

# additional aesthetics
mtcars$cyl <- as.factor(mtcars$cyl)
p <- ggplot(data=mtcars, aes(x=hp, y=qsec, col=cyl))
p1 <- p + geom_point()
p1

# other geometries
p + geom_line(size=mtcars$mpg/5)
p + geom_step(size=mtcars$mpg/5)

# statistical summary, like a regression line
ggplot(data=mtcars, aes(x=hp, y=qsec)) +
  geom_point(data=mtcars, aes(color=cyl, size=mpg/5)) +
  geom_smooth(method="lm")

# modify axis, legend and plot labels
ggplot(data=mtcars, aes(x=hp, y=qsec)) +  
  geom_point(data=mtcars, aes(color=cyl,size=mpg/5)) +
  geom_smooth(method="lm") +
  labs(x="Horse Power", y="Time to Quarter Mile",
       size="Miles per Gallon", color="# of cylinders")

# split data into subsets and plot each subset on a different panel
ggplot(data=mtcars, aes(x=hp, y=qsec)) +
  geom_point(data=mtcars, aes(color=cyl,size=mpg/5)) +
  geom_smooth(method="lm") +
  labs(x="Horse Power", y="Time to Quarter Mile",
       size="Miles per Gallon", color="# of cylinders") +
  facet_grid(. ~ cyl)