# Question 1

## Sub question a
library(pheatmap)
data <- read.table("data/raw/county_facts_and_primary_results.txt", header = TRUE)
heatmap(as.matrix(data[,-1]))
heatmap(as.matrix(data[,-1]), scale = "row")

## Sub question b
correlation_matrix = cor(data[,-1])
pheatmap(correlation_matrix)

## Sub question c
for (column in colnames(data)) {
  print(column)
  print(sum(data[[column]] == -1))
}

# Question 2
p <- prcomp(data[,-1])

plot(p, 
     main = "Plot of Principal Components", 
     xlab = "Principal Components")

biplot(p,cex=c(0.5,0.5))

# Question 3
library(ggplot2)
p1 <- ggplot(data, aes(x=POP2014, y=HOFIRMS)) + geom_point() +
  xlab("Estimated population 2014") +
  ylab("Hawaiian-owned firms (%)")
p2 <- ggplot(data, aes(x=POP2014, y=NOFIRMS)) + geom_point() +
  xlab("Estimated population 2014") +
  ylab("Alaska-owned firms (%)")
p3 <- ggplot(data, aes(x=POP2014, y=SALES2)) + geom_point() +
  xlab("Estimated population 2014") +
  ylab("Retail sales ($1,000)")
p4 <- ggplot(data, aes(x=POP2014, y=BOFIRMS)) + geom_point() +
  xlab("Estimated population 2014") +
  ylab("Black-owned firms (%)")
p5 <- ggplot(data, aes(x=POP2014, y=SHIPM)) + geom_point() +
  xlab("Estimated population 2014") +
  ylab("Manufacturer shipments ($1,000)")
grid.arrange(p1, p2, p3, p4, p5, nrow = 2)

# Question 4
boxplot(data[,-1])
centered_data <- scale(data[,-1], center = TRUE, scale = FALSE)
boxplot(centered_data)
transformed_data <- scale(data[,-1], center = TRUE, scale = TRUE)
boxplot(transformed_data)

pca_scaled <- prcomp(transformed_data)
summary(pca_scaled)
plot(pca_scaled)
biplot(pca_scaled, cex = c(0.5, 0.5))