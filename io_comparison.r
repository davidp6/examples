# Test out different file formats to determine 
# a) best read speed
# b) best write speed
# c) best storage size

# options
# rds
# data.table
# feather

# set up R
rm(list=ls())
library(data.table)
library(feather)


# test data: GBD results


# a) read speed


