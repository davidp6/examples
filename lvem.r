# -------------------------------------------------------------------
# David Phillips
#
# 12/14/2017
# Example of expectation-maximization using latent variable analysis
# -------------------------------------------------------------------


# --------------------
# Set up R
rm(list=ls())
set.seed(1)
library(data.table)
library(lavaan)
library(ggplot2)
library(RColorBrewer)
# --------------------


# ------------------------------------------------------------
# Input parameters

# tolerance (when to stop the EM algorithm)
tol = .0001

# level of missingness in simulated data (proportion of data)
z = .05
# -----------------------------------------------------------


# -------------------------------------------
# Set up structural model 
# from canonical political democracy example
model <- '
   # latent variables
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8
   # regressions
     dem60 ~ ind60
     dem65 ~ ind60 + dem60
   # residual covariances
     y1 ~~ y5
     y2 ~~ y4 + y6
     y3 ~~ y7
     y4 ~~ y8
     y6 ~~ y8
'
# -------------------------------------------


# ------------------------------------------------------------------
# Simulate missing data

# load complete data
realData = data.table(PoliticalDemocracy)

# create some missingness 
# (this is MCAR, but it should be ok if it's only MAR)
observedData = copy(realData)
n = nrow(observedData)
names = names(observedData)
for(c in names) observedData[runif(n*z, 1, n),(c):=NA]
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Run LVEM

# initialize convergence metric at something large
conv = Inf

# initialize missing values with arbitrary numbers
modelData = copy(observedData)
means = observedData[, lapply(.SD, mean, na.rm=TRUE), .SDcols=names]
for(c in names) modelData[is.na(get(c)), (c):=means[[c]]]

# run EM algorithm
i=1
while (conv>tol) {
	# store/restore initial state
	initData = copy(modelData)

	# fit latent variable model
	fit = sem(model, modelData)
	preds = data.table(lavPredict(fit, type='ov'))

	# update previously-missing values with predictions
	for(c in names) modelData[is.na(observedData[[c]]), (c):=preds[is.na(observedData[[c]])][[c]]]

	# evaluate convergence
	prev = conv
	conv = mean(sqrt((initData - modelData)^2))
	print(paste0('Iteration: ', i, ', RMSE compared to last run:', round(conv, 9)))
	i=i+1
} 
# ------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Evaluate performance

# assemble data
evalData = cbind(melt(realData), melt(observedData), melt(modelData))
evalData = evalData[, c(1,2,4,6), with=FALSE]
setnames(evalData, c('variable','real_value','observed_value','model_value'))

# plot performance among missing values
lims = range(evalData$real_value)
ggplot(evalData[is.na(observed_value)], aes(y=model_value, x=real_value)) + 
	geom_point(aes(color=variable)) + 
	geom_abline(intercept=0, slope=1) + 
	geom_smooth(method='lm') + 
	scale_x_continuous(limits=lims) + 
	scale_y_continuous(limits=lims) + 
	scale_color_manual('Variable', values=brewer.pal(length(names), 'Paired')) + 
	labs(y='Imputation', x='Real Value') + 
	theme_bw()
# ------------------------------------------------------------------------------
