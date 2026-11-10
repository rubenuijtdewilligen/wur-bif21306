x <- c(1,2,3)

# linearly increasing relationship
y <- c(2,4,6)
cor(x, y, method="pearson")
cor(x, y, method="spearman")
# both 1

# linear decreasing relationship
y <- c(6,4,2)
cor(x, y, method="pearson")
cor(x, y, method="spearman")
# both -1

# non-linear increasing relationship
y <- c(5,10,30)
cor(x, y, method="pearson")
# 0.9449112 -> strong, but not linear, so Pearson < 1
cor(x, y, method="spearman")
# 1 -> Spearman only looks at rank (1<2<3 stays 5<10<30)

y <- c(4,4,4)
cor(x, y, method="pearson")
cor(x, y, method="spearman")
# both NA because the standard deviation is zero