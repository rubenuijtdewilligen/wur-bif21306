library("dplyr")

### Question a
boxplot(ndata_named)
# some arrays have a wider ranger of expression than others near them
# for example cln3.1 might be an outlier, and elu0

### Question b
afdata <- select(ndata_named, starts_with("alpha"))
boxplot(afdata)

### Question c
boxplot(scale(afdata,center=TRUE,scale=FALSE))

### Question d
boxplot(scale(afdata,center=TRUE,scale=TRUE))

### Question e
nrmdata <- scale(afdata,center=TRUE,scale=TRUE)
# you could argue that only mean centering is sufficient here, because the data is already log-scaled
# however, there is no guarantee that this does not leave in technical variation, so also scaling can be justified

