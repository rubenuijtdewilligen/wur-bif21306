data(iris)

### THEORY

# PCA is used to compress a 3D plot
# you try to find directions in data which
#   - retain as much data as possible
#   - make projected data uncorrelated
#   - minimize squared reconstruction error

# can be found by eigenanalysis of covariance matrix

# Principal components are ordered:
#   - PC1 is the direction of most variation
#   - PC2 is the direction of most variation perpendicular to PC1
#   - PC3 is the direction of most variation perpendicular to PC1 and PC2
#   - etc.

### PERFORM PCA ON MULTIDIMENSIONAL DATA

# perform Principal Component Analysis on numeric iris columns (1-4)
p <- prcomp(iris[, 1:4])
print(p)

# the standard devitations show the dispersion (square root of the eigenvalues) along each PC
# the rotations show the "loadings" (coefficients) that indicate the weight of each original variable

### SUMMARY AND RETAINED VARIANCE

# look at the proportion of variation per Principal Component
summary(p)
# Importance of components:
#                           PC1     PC2    PC3     PC4
# Standard deviation     2.0563 0.49262 0.2797 0.15439
# Proportion of Variance 0.9246 0.05307 0.0171 0.00521
# Cumulative Proportion  0.9246 0.97769 0.9948 1.00000

# gives:
#   - standard deviation per PC
#   - proportion of variance: how much percent of the totl vrition is explained by each PC
#   - cumulative proportion: the sum of explained variance

# rule-of-thumb: to remove noise, retain 90-95% of variation

# visualize the variance per PC with a scree plot
plot(p, main = "PCA Variances per Component")

### SCALING

# just like covariance, PCA is sensitive to the scale/units of variables
# by default scale = FALSE, but scaling (scale = TRUE) ensures all variables get equal weight
p_scaled <- prcomp(iris[, 1:4], scale = TRUE)
summary(p_scaled)

# without scaling, one dominant variable with large units could pull all variance to PC1

### VISUALIZATION

biplot(p, main = "PCA Biplot (Unscaled)")
biplot(p_scaled, main = "PCA Biplot (Scaled)")

# a biplot shows:
#   - all samples projected onto the first two PCs
#   - variable loadings on the first two PCs (vectors that show how much the variable contribute)