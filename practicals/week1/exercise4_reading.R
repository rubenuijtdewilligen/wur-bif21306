### read.csv()

# just reading in data
mydata_csv1 <- read.csv(file = "data/raw/griffins.csv")
print(mydata_csv1)

# setting the first column as row names
mydata_csv2 <- read.csv(file = "data/raw/griffins.csv", row.names = 1)
print(mydata_csv2)

# setting text variables to type 'factor'
mydata_csv3 <- read.csv(file = "data/raw/griffins.csv", row.names = 1, stringsAsFactors = TRUE)
print(mydata_csv3)
class(mydata_csv3$Sex)

### read.table()

# just reading in data from a tab seperated file
mydata_txt1 <- read.table(file = "data/raw/griffins.txt")
print(mydata_txt1)

# setting the first row as names
mydata_txt2 <- read.table(file = "data/raw/griffins.txt", header = TRUE)
print(mydata_txt2)

# setting the first column as row names
mydata_txt3 <- read.table(file = "data/raw/griffins.txt", header = TRUE, row.names = 1)
print(mydata_txt3)

# setting header, row names and string to factor with one line
mydata_txt4 <- read.table(file = "data/raw/griffins.txt", header = TRUE, row.names = 1, stringsAsFactors = TRUE)
print(mydata_txt4)
class(mydata_txt4$Sex)