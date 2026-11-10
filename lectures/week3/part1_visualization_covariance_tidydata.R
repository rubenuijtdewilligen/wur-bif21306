data(iris)

### VISUALIZATION

# summary statistics per category
by(iris$Petal.Length, iris$Species, summary)
# iris$Species: setosa
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   1.400   1.500   1.462   1.575   1.900 
# -------------------------------------------------------------------------- 
#   iris$Species: versicolor
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 3.00    4.00    4.35    4.26    4.60    5.10 
# -------------------------------------------------------------------------- 
#   iris$Species: virginica
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 4.500   5.100   5.550   5.552   5.875   6.900 

# basic boxplot of measured continuous variables
boxplot(iris[, 1-4], main = "Iris Parameter Distributions")

# density plot per category using ggplot2
library(ggplot2)
ggplot(data = iris, aes(x = Petal.Length)) +
  geom_density(aes(fill = Species, color = Species, alpha = 0.7)) +
  labs(x = "Petal Length", y = "Density", title = "Density Distribution of Petal Length")

# violin plot
ggplot (data=iris, aes(x=Species, y=Petal.Length)) +
  geom_violin(aes(color=Species, fill=Species)) +
  labs(x = "Species", y = "Petal Length", title = "Violin Plot per Species")

# cross tabulation
iris$Small <- (iris$Petal.Length < 4)
xtab <- xtabs(~ Species + Small, data = iris)
print(xtab)
#             Small
# Species      FALSE TRUE
# setosa           0   50
# versicolor      39   11
# virginica       50    0

# proportions
prop.table(xtab)      # total proportion
#           Small
# Species         FALSE       TRUE
# setosa     0.00000000 0.33333333
# versicolor 0.26000000 0.07333333
# virginica  0.33333333 0.00000000

prop.table(xtab, 1)   # row-wise proportion, so within the species
#           Small
# Species    FALSE TRUE
# setosa      0.00 1.00
# versicolor  0.78 0.22
# virginica   1.00 0.00

# mosaic plot visualization
library(vcd)
mosaic(~ Species + Small, data = iris, shade = TRUE, legend = FALSE)

# 2d histogram of Sepal.length vs Petal.length
ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length)) +
  geom_bin2d(drop=FALSE) +
  labs(x = "Sepal Length", y = "Petal Length", title = "2d Histogram Sepal length vs Petal length")

# 2nd density plot of Sepal.length vs Petal.length
ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length)) +
  geom_density2d() +
  geom_point() +
  labs(x = "Sepal Length", y = "Petal Length", title = "2d Density Plot Sepal length vs Petal length")

### COVARIANCE

# covariance matrix
cov_matrix <- cov(iris[, 1:4])
print(cov_matrix)

# covariance depends on scale of variables
cov(iris$Sepal.Length, iris$Petal.Length)
# [1] 1.274315
cov(iris$Sepal.Length, iris$Petal.Length + 5)
# [1] 1.274315
cov(iris$Sepal.Length, 3 * iris$Petal.Length)
# [1] 3.822946

# Pearson correlation is the covariance normalized to the range [-1, 1]
cov(iris$Sepal.Width,iris$Sepal.Length)
# [1] -0.042434
cor(iris$Sepal.Width,iris$Sepal.Length)
# [1] -0.1175698
cov(scale(iris$Sepal.Width),
      + scale(iris$Sepal.Length))
#            [,1]
# [1,] -0.1175698

# complete matrix
cor_pearson <- cor(iris[, 1:4], method = "pearson")
print(cor_pearson)

# Pearson correlation assumes a linear relation
cor(iris$Sepal.Length,iris$Sepal.Length)
# [1] 1
cor(iris$Sepal.Length,iris$Sepal.Length^4)
# [1] 0.9723453
# Spearman correlation is the correlation of ranks
cor(iris$Sepal.Length,iris$Sepal.Length^4, method="spearman")
# [1] 1

### VISUALISE EVEN AFTER LOOKING AT CORRELATION

# main visualization of two or three continuous variables
plot(iris$Sepal.Length, iris$Petal.Length)
ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, color=Species)) +
  geom_point()

# adding a regression line can help interpretation
ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length)) +
  geom_point() +
  geom_smooth()

ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length)) +
  geom_point() +
  geom_smooth(method = "lm")

# for discrete variables, we can add jitter (a little noise)
ggplot(data=iris, aes(x=Species,y=Petal.Length)) +
  geom_point()

ggplot(data=iris, aes(x=Species,y=Petal.Length)) +
  geom_point() +
  geom_jitter(width = 0.1, height = 0)

# multiple scatterplots
pairs(iris[,1:4])

# visualizing matrices
image(cov(iris[,1:4]))
image(cor(iris[,1:4]), zlim = c(-1,1))

# heatmaps
heatmap(as.matrix(iris[,1:4]))
heatmap(cor(iris[,1:4]), scale="none")

### TIDYVERSE

# Data is tidy if:
#   - Each variable is in its own column
#   - Each observation, or case, is in its own row
#   - Each value is a cell; each cell is a single value.

wide_data <- data.frame(
  id = c("A", "B", "C"),
  bp1 = c(100, 140, 120),
  bp2 = c(120, 115, 125)
)

print(wide_data)

# method 1: using reshape2
library(reshape2)
long_data_melt <- melt(
  wide_data, 
  id.vars = "id",                 # the column to keep as-is
  variable.name = "measurement",  # name for the new column of the old columns
  value.name = "value"            # name for the measurements
)
print(long_data_melt)

# method 2: using tidyr
library(tidyr)
long_data_pivot <- wide_data %>%
  pivot_longer(
    cols = c(bp1, bp2),           # What columns tot convert to long
    names_to = "measurement",     # name for the measurement categories
    values_to = "value"           # name for the numbers
  )
print(long_data_pivot)