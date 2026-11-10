### Question a
num <- 1000
sds <- apply(nrmdata,1,sd)
ind <- order(sds,decreasing=TRUE)
subdata <- nrmdata[ind[1:num],]
# this selects the most variable genes because we select the top 1000 after sorting by the highest standard deviation

### Question b
heatmap(as.matrix(subdata))
# the heatmap does not really show any order
pairs(subdata)
# directly along the diagonal of the pairs plot, correlation appears.
# alpha49 and alpha56 are next to each other and show some correlation,
# alpha49 and alpha119 however, show no correlation.

### Question c
image(cor(subdata))
# this heatmap corrorates my answer to question b.
# along the diagonal, the correlation coefficients are higher than in the corners.

### Question d
library(tidyr)
gene_data <- rownames_to_column(as.data.frame(subdata), "gene")
gene_data <- gene_data[1:5,]
long_data <- gene_data %>%
  pivot_longer(
    cols=starts_with("alpha"),
    names_to="alpha",
    values_to="value"
  )

### Question e
library(ggplot2)
library(readr)
ggplot(long_data, aes(x = parse_number(alpha), y = value, color = gene)) +
  geom_point() +
  geom_smooth() +
  labs(
    x = "Time"
  ) +
  facet_wrap(vars(gene))
# the plots look line a sin, which is explained by this being the cell cycle

### Question f
p <- prcomp(subdata)
plot(p)
summary(p)
#                           PC1    PC2    PC3     PC4     PC5     PC6    PC7     PC8     PC9   PC10    PC11
# Standard deviation     3.6428 3.1646 3.0265 2.11544 1.69588 1.50348 1.3897 1.15644 1.12642 1.0500 1.00288
# Proportion of Variance 0.2515 0.1898 0.1736 0.08482 0.05451 0.04284 0.0366 0.02535 0.02405 0.0209 0.01906
# Cumulative Proportion  0.2515 0.4413 0.6149 0.69976 0.75427 0.79711 0.8337 0.85906 0.88311 0.9040 0.92307

# you need the first 10 PC's to explain 90.4% (>90%) of variation

### Question g
biplot(p,cex=c(0.5,0.5))
# alpha77 and alpha84 contribute a lot to PC2
# alpha1, alpha2, alpha56 and alpha49 contribute a lot to PC1

### Question h
par(mfrow=c(3,3))
for (i in 1:9) {
  plot(p$rotation[,i])
}
# the first PCs are sine waves, because they capture the main variation in the data