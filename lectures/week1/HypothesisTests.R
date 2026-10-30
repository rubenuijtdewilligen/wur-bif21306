load("data/raw/Singh.rda")

healthy <- Singh$X[Singh$y == 1,] # 1 = healthy
diseased <- Singh$X[Singh$y == -1,] # -1 = diseased

gene_nr <- 1 # the first gene

t.test(healthy[,gene_nr], diseased[,gene_nr], "two.sided")

# Apply to all genes
pvalues <- sapply(1:ncol(healthy), function(i) {
  t.test(healthy[, i], diseased[, i], "two.sided")$p.value
})

hist(pvalues, 
     breaks = 50, 
     main = "Histogram of P-values", 
     xlab = "P-value", 
     ylab = "Frequency")

# Correct with Benjamini-Hochberg to check the False Discovery Rate and decrease the amount of false positives
adjpvalues <- p.adjust(pvalues, method = "BH")

sum(adjpvalues < 0.05)