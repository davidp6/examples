rm(list=ls())
set.seed(1)
library(Amelia)
library(ggplot2)
library(data.table)

# test amelia extrapolation
data <- data.table(time=seq(1, 25))
data[, x_true:=1 + data$time*2 + rnorm(nrow(data), 0, 5)]
data[, y_true:=2 + data$time*3 + data$x*4 + rnorm(nrow(data), 0, 5)]

# induce missingness in the last observation (and some other random observations)
data[, x_observed:=x_true]
data[, y_observed:=y_true]
data[c(1,3,7,14,25),x_observed:=NA]
data[c(2,8,17,21,25),y_observed:=NA]

# try to impute
# returns the warning and missing values in row 25
imp1 <- amelia(data[,c('time','x_observed','y_observed')], m=1, ts='time')

# try to impute using a silly workaround
data[, workaround_variable:=runif(nrow(data))]
imp2 <- amelia(data[,c('time','x_observed','y_observed','workaround_variable')], m=1, ts='time')

# set up to graph
tmp1 = data.table(imp1$imputations$imp1)
tmp2 = data.table(imp2$imputations$imp1)
setnames(tmp1, c('x_observed','y_observed'), c('x_imp1','y_imp1'))
setnames(tmp2, c('x_observed','y_observed'), c('x_imp2','y_imp2'))
data = merge(data, tmp1, by='time')
data = merge(data, tmp2, by='time')
data$workaround_variable.x <- NULL
data$workaround_variable.y <- NULL
data[!is.na(x_observed), x_imp1:=NA]
data[!is.na(x_observed), x_imp2:=NA]
data[!is.na(y_observed), y_imp1:=NA]
data[!is.na(y_observed), y_imp2:=NA]
graphData = melt(data, id.vars='time')
graphData[, c('variable','version') := tstrsplit(variable, "_", fixed=TRUE)]

# plot
ggplot(graphData, aes(y=value, x=time, color=version)) + 
	geom_point(size=2.5) + 
	facet_wrap(~variable, scales='free')
