# testing ways to load data straight from basecamp

library(R.utils) 
library(readxl) 


# fileURL = 'https://3.basecamp.com/3769859/buckets/4025874/uploads/773079576/download/VL%20PNLS%20Labo%20Data.csv?attachment=true'
fileURL = 'https://3.basecamp.com/3769859/buckets/4025874/uploads/773079576/download/VL%20PNLS%20Labo%20Data.csv'

outFile = 'C:/Users/davidp6/Downloads/test.xlsx'

downloadFile(fileURL, outFile, username = "davidp6@uw.edu", password ="")



data = read.csv(url(fileURL))
data = read.table(fileURL)
