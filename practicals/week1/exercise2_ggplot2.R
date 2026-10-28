library(car)
data(Pottery)
View(Pottery)
library(ggplot2)

# Question 2a
ggplot(data=Pottery, aes(x=Site, y=Al))

# Question 2b
ggplot(data=Pottery, aes(x=Site, y=Al)) + geom_boxplot()

# Question 2c
ggplot(data=Pottery, aes(x=Site, y=Al)) + geom_boxplot()
ggplot(data=Pottery, aes(x=Site, y=Fe)) + geom_boxplot()
ggplot(data=Pottery, aes(x=Site, y=Mg)) + geom_boxplot()
ggplot(data=Pottery, aes(x=Site, y=Ca)) + geom_boxplot()
ggplot(data=Pottery, aes(x=Site, y=Na)) + geom_boxplot()

# Question 2d
library(reshape2)
MeltedPottery <- melt(Pottery)

# Question 2e
ggplot(data=MeltedPottery, aes(x=variable, y=value, col=variable)) + geom_boxplot() + facet_grid(. ~ Site)

# Question 2f
ggplot(data=MeltedPottery, aes(x=variable, y=value, col=variable)) + geom_boxplot() + facet_grid(. ~ Site) + labs(x="Element", y="Concentration", col="Element")
