# simulate prevalence and incidence
rm(list=ls())
library(data.table)
library(ggplot2)
set.seed(1)

# parameters
p = .1 # force of infection per month
durMean = .5 # average duration of illness in fractions of a year
durSd = 0 # sd duration of illness in fractions of a year
N = 100 # population size

# sim
time = seq(2000, 2010, by=1/12)
incidence = data.table(sapply(time, function(x) { rbinom(N, 1, p) } ))

