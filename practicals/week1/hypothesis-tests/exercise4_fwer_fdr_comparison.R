methods <- c("bonferroni", "BH", "holm", "hochberg", "hommel", "BY")

### Question a
theData <- read.csv(file="data/raw/dietaryvariables.csv")

### Question c
theData <- theData[order(theData$Raw.p),]
theData

### Question d
Y <- sapply(methods, function(m) p.adjust(theData$Raw.p, method = m))

theData <- cbind(theData, Y)
theData

### Question e
X <- theData$Raw.p

matplot(X, Y, xlab="Raw p-value", ylab="Adjusted p-value", type="l", asp=1, col=1:6, lty=1, lwd=2)
legend("bottomright", legend = methods, col=1:6, cex=1, pch=16)
abline(0, 1, col=1, lty=2, lwd=1)

### Question f

# all corrected p-values are higher than the diagonal dotted line, so false positives are being filtered
# Bonferroni is the most strict method because it checks the Family-Wise Error Rate, but all (except BH) methods are almost as strict
# BH shows a milder curve. However, even though the correction is less heavy, the impact on this specific dataset is also small.
# There is still only one variable that is significant.