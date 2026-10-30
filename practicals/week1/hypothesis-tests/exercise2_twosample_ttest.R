head(mtcars)

### Question a
manual <- which(mtcars$am==0)
automatic <- which(mtcars$am==1)

boxplot(mtcars$mpg[manual], mtcars$mpg[automatic], ylab="mpg", names=c("manual", "automatic"))

### Question b
t.test(mtcars$mpg[manual], mtcars$mpg[automatic], var.equal = TRUE, alternative="less")

# t = -4.1061, df = 30, p-value = 0.0001425
# mean of x mean of y
#  17.14737  24.39231
# manual cars have significantly less mpg than automatic cars

### Question c
distr <- sapply(1:10000, function(i) {
  index <- sample(mtcars$am)
  manual <- which(index==0)
  automatic <- which(index==1)
  
  t.test(mtcars$mpg[manual], mtcars$mpg[automatic], var.equal = TRUE, alternative="less")$statistic
})
hist(distr)

manual <- which(mtcars$am == 0)
automatic <- which(mtcars$am==1)

real_t_statistic <- t.test(mtcars$mpg[manual], mtcars$mpg[automatic], var.equal = TRUE, alternative="less")$statistic

points(real_t_statistic, 0, col="red", pch=16)
sprintf("%f", sum(distr < real_t_statistic)/length(distr))

# p-value = 0.0002. From all 10000 permutations, only 2 gave a more extreme result than the real data.
# we conclude that manual cars have significantly less mpg

### Question d

# the reason that the p-values 0.0002 (question c) and 0.000142 (question b) don't match is that we shuffle the labels
# 'only' 10000 times, which gives us an approximation. this limits our precision to steps of 1/10000 (0.0001).
# this gap can be closed by increasing the number of permutations. the empirical p-value will converge almost
# exactly on the theoretical value.