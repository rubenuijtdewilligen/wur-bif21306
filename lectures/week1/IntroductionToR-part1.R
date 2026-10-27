# R can be used as an expensive calculator
(3^2 + 6) / (3 + 2)
# parentheses can be used for precedence control or readability
3^2 + (6 / 3) + 2
# don't use them sparingly

# everything in R is an object
x <- 3
y <- 3
z <- x*y

ls()

z # auto printing, mainly used in console
print(z) # explicit print, mainly used in scripts

(z <- x * y) # print after assignment

# this is a function without an argument:
date()
# this is a function with arguments:
round(pi, digits=2)

# loading a package can be done using library()
library(car) # which is recommended, it throws an error if the package is missing
# or using require()
require(car) # which returns TRUE when loaded or FALSE when not loaded

# unloading a package can be done using detach()
detach("package:car")
# the "package:" is needed because there are other things that can be detached

# vectors are created using the function c()
vector1 <- c(1,2,3,4,5,6)
print(vector1) # [1] 1 2 3 4 5 6
vector2 <- c("a", "b", "c", "d")
print(vector2) # [1] "a" "b" "c" "d"

# some useful vector functions:
1:5 # [1] 1 2 3 4 5
seq(from=5, to=13, by=2.5) # [1]  5.0  7.5 10.0 12.5
rep(c(1, 2, 3), times=2) # [1] 1 2 3 1 2 3
length(vector1) # [1] 6

vector1 <- c(10,4,2,7,1,6)
sort(vector1) # [1]  1  2  4  6  7 10
sort(vector1, decreasing = TRUE) # [1] 10  7  6  4  2  1

# R matches the elements of both vectors
a <- c(1,2,3)
b <- c(6,5,4)
a + b # [1] 7 7 7

a <- c(1,2,3)
b <- c(6,5,4, 3)
a + b # [1] 7 7 7 4, Warning message: In a + b : longer object length is not a multiple of shorter object length

a <- c(1,2,3)
b <- c(6,5,4, 3, 2, 1)
a + b # [1] 7 7 7 4 4 4

# a matrix is several vectors saved together
matrix1 <- matrix(1:20, nrow=2, ncol=10)
print(matrix1)
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    3    5    7    9   11   13   15   17    19
# [2,]    2    4    6    8   10   12   14   16   18    20

# function argument byrow indicates whether rows or columns are filled first
matrix2 <- matrix(1:20, nrow=2, ncol=10, byrow=TRUE)
print(matrix2)
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    2    3    4    5    6    7    8    9    10
# [2,]   11   12   13   14   15   16   17   18   19    20

# rbind and cbind make a matrix from multiple vectors
a <- c(1,2,3)
b <- c(4,5,6)
rbind(a,b)
# [,1] [,2] [,3]
# a    1    2    3
# b    4    5    6
cbind(a,b)
a <- c(1,2,3)
# a b
# [1,] 1 4
# [2,] 2 5
# [3,] 3 6

# dimensions of a matrix:
matrix1 <- matrix(1:20, nrow=2, ncol=10)
dim(matrix1) # [1]  2 10
a <- c(1,2,3)
dim(a) # NULL
length(a) # [1] 3

# extracting elements or getting subsets of vectors
vector1 <- 1:10
vector1[5] # [1] 5
vector1[5:10] # [1]  5  6  7  8  9 10
vector1[c(1,5,10)] # [1]  1  5 10
vector1[-5] # [1]  1  2  3  4  6  7  8  9 10
vector1[-(5:10)] # [1] 1 2 3 4
vector1[-c(1,5,10)] # [1] 2 3 4 6 7 8 9

# subsetting matrices
matrix1 <- matrix(1:20, nrow=2, ncol=10)
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
# [1,]    1    3    5    7    9   11   13   15   17    19
# [2,]    2    4    6    8   10   12   14   16   18    20
matrix1[1,4] # [1] 7
matrix1[1,] # [1]  1  3  5  7  9 11 13 15 17 19
matrix1[,4] # [1] 7 8
matrix1[,-c(4,5)]
# [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
# [1,]    1    3    5   11   13   15   17   19
# [2,]    2    4    6   12   14   16   18   20

# logical values are just booleans (TRUE / FALSE), abbreviated to T and F
# logicals are also numbers (TRUE = 1, FALSE = 0), so you can add them
print(TRUE + TRUE + FALSE + TRUE) # [1] 3

1==2 # [1] FALSE
1 > 2 # [1] FALSE
(2-1) <= 2 # [1] TRUE
1 != (2+3) # [1] TRUE

vector1 <- c(1,2,3,4,5,6)
vector2 <- c(2,2,3,3,4,4)
vector1 == vector2 # [1] FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
vector2 < vector1 # [1] FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE

# strings in R:
string1 <- "This is a character string!"
string1 # [1] "This is a character string!"
# R treats strings as a single entity, so length = 1
length(string1) # [1] 1
nchar(string1) # [1] 27

# a factor is an efficient way to store character data where elements are repeated
f1 <- c("Male", "Male", "Male", "Female", "Female", "Female")
class(f1) # [1] "character"
f2 <- as.factor(f1)
f2
# [1] Male   Male   Male   Female Female Female
# Levels: Female Male

# a list can be used to group any mix of R structures and objects
record <- list(name="Fred", spouse="Mary", no.children=3, child.ages=c(4,7,9))
record
# $name
# [1] "Fred"

# $spouse
# [1] "Mary"

# $no.children
# [1] 3

# $child.ages
# [1] 4 7 9

# list components are accessed by the dollar operator $
record$name # [1] "Fred"
record$child.ages # [1] 4 7 9
# or by the double square brackets operator [[ ]]
record[[2]] # [1] "Mary"
record[1:2]
# $name
# [1] "Fred"

# $spouse
# [1] "Mary"

# a date.frame is a matrix where the columns can be of different classes numeric, character, factor, ...
mydata <- data.frame(person=c("Peter", "Lois", "Meg", "Chris", "Stewie"),
                     age=c(42,40,17,14,1),
                     sex=factor(c("M", "F", "F", "M", "M")))
mydata
# person age sex
# 1  Peter  42   M
# 2   Lois  40   F
# 3    Meg  17   F
# 4  Chris  14   M
# 5 Stewie   1   M

mydata[,1] # [1] "Peter"  "Lois"   "Meg"    "Chris"  "Stewie"
mydata[2,]
#   person age sex
# 2   Lois  40   F

# Classes
a <- 1:5
b <- seq(from=1.5, to=5.5, by=1)
d <- c("January", "is", "cold")
e <- c(TRUE, FALSE, TRUE)
f <- as.factor(d)
f
# [1] January is      cold   
# Levels: cold is January

class(a) # [1] "integer"
class(b) # [1] "numeric"
class(d) # [1] "character"
class(e) # [1] "logical"
class(f) # [1] "factor"

as.numeric(d)
# [1] NA NA NA
# Warning message:
#   NAs introduced by coercion 

as.character(a) # [1] "1" "2" "3" "4" "5"

### DATA MANIPULATION IN R
# data() brings up a list of ready-to-use datasets
data()
# but we probably want to read data from files
# R uses the concept of a working directory, where it saves and reads all data from
# you can set it using setwd()
setwd("/Users/ruben/dev/bif21306-dav")
# and get it using getwd()
getwd()

# you can read files using read.table() or read.csv()
# you can read Excel using the package gdata or XLConnect
# filenames can be web urls
# writing can be done using write.table() or write.csv()
# if you want to save as .RData (binary), use
save(mydata, vector1, file = "data/processed/lectures/Mydatafile.RData")
# and load it back using
load("data/processed/lectures/Mydatafile.RData")
