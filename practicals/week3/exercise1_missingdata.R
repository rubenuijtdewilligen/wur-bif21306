### Question a
mydata = read.table("data/raw/week3_combined.txt", header = TRUE, sep = "\t")

names(mydata)
dim(mydata)
# 6178 rows, 83 cols

image(as.matrix(mydata[,-1]))
# some arrays are (almost) completely missing. these are the white horizontal lines.
# some genes are poorly measured, indicated by the vertical white lines.

### Question b
quantile(mydata[,-1],na.rm=TRUE)

### Question c
nmissing <- length(which(is.na(as.matrix(mydata[,-1]))))
ntotal <- nrow(mydata) * (ncol(mydata) - 1)
nmissing/ntotal
# 0.1165 -> 11.65% of data is missing

### Question d
ndata = read.table("data/raw/week3_imputed.txt", header = TRUE, sep = "\t")

dim(ndata)
# 5504 rows, 70 cols
# 6178-5504 = 673 entries were removed
# 83-70 = 13 variablaes were removed

### Question e
heatmap(as.matrix(ndata[,-1]))

### Question f
library(tibble)
ndata_named <- column_to_rownames(ndata, var = "X")
heatmap(as.matrix(ndata_named))
