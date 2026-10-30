### Question a
load("data/raw/Singh.rda")

### Question b
names(Singh)
dim(Singh$X)
Singh$y

### Question c
healthy <- Singh$X[Singh$y == 1,]
diseased <- Singh$X[Singh$y == -1,]

### Question d
t.test(healthy[,1], diseased[,1], "two.sided")
# t = -1.8275, df = 71.946, p-value = 0.07176
# we have not shown a significant difference in expression level for gene 1 between the 2 groups

### Question e
pvals <- sapply(1:ncol(healthy), function(i) {
  t.test(healthy[,i], diseased[,i], "two.sided")$p.value
})
hist(pvals)

sum(pvals < 0.05)
# there are 5454 significant genes in the dataset

### Question f

# in question e, we can expect 12600*0.05=630 false positives
# the Benjamin-Hochberg method corrects this by checking the FDR
adjpvalues <- p.adjust(pvals, method = "fdr")
sum(adjpvalues < 0.05)
# after the correction, 2842 genes are considered to have differently expressed profiles

### Question g
library(ggplot2)

avg.healthy <- abs(colMeans(healthy))
avg.diseased <- abs(colMeans(diseased))

log2FoldChange <- log2(avg.healthy) - log2(avg.diseased)

de <- data.frame(pvalue=adjpvalues, log2FoldChange=log2FoldChange)

# determine if no difference, or up or down regulated
de$diffexpressed <- "NO"
de$diffexpressed[de$log2FoldChange > 0.6 & de$pvalue < 0.05] <- "UP"
de$diffexpressed[de$log2FoldChange < -0.6 & de$pvalue < 0.05] <- "DOWN"

p1 <- ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) +
  geom_point() +
  geom_vline(xintercept=c(-0.6, 0.6), col="red") +
  geom_hline(yintercept=-log10(0.05), col="red")
print(p1)

# points in green are not significantly different or have small fold changes
# red is significantly down regulated, blue is significantly up regulated
# the most promising genes lie furthest away from the origin