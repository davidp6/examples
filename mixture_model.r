# ----------------------------------------------------
# David Phillips
#
# 4/16/2018
# Example of using mixtools to do a mixture regression
# ----------------------------------------------------


# --------------------
# Set up R
rm(list=ls())
library(mixtools)
library(data.table)
library(stringr)
library(ggplot2)
set.seed(1)
# --------------------


# ----------------------------------------------
# Load/prep data

# load
data(NOdata)

# show that it's clearly a mixture model
ggplot(NOdata, aes(y=Equivalence, x=NO)) + 
	geom_point()
# ----------------------------------------------

# ------------------------------------------------------------------------------------
# Run analysis

# regress using EM algorithm
em.out <- regmixEM(NOdata$Equivalence, NOdata$NO)

# display coefficients
summary(em.out)

# get fitted values for both 'compositions'
emfit = em.out$x %*% em.out$beta
colnames(emfit) = c('comp.1_em','comp.2_em')
NOdata = cbind(NOdata, emfit)

# regress using MH algorithm
mh.out <- regmixMH(NOdata$Equivalence, NOdata$NO)

# display coefficients
summary(mh.out)

# wrangle posteriors into correctly-shaped matrix to get mean values for predictions 
# (is there a better way?)
mh.out$beta = data.table(mh.out$theta[,1:4])[, lapply(.SD, mean)]
mh.out$beta = melt(mh.out$beta, value.name='comp')
mh.out$beta[, c('variable', 'compnum'):=tstrsplit(variable, '.', fixed=TRUE)]
mh.out$beta = as.matrix(dcast(mh.out$beta, variable~compnum, value.var='comp')[,2:3])
colnames(mh.out$beta) = c('comp.1_mh','comp.2_mh')

# get fitted values for both 'compositions' 
# (the MH fitted values are way off? must be some error on my side...)
mhfit = exp(mh.out$x %*% mh.out$beta)
NOdata = cbind(NOdata, mhfit)
# ------------------------------------------------------------------------------------


# ------------------------------------------------------------------------
# Graph

# display graph
ggplot(NOdata, aes(y=Equivalence, x=NO, color=em.out$posterior[,1])) + 
	geom_point() + 
	geom_line(aes(y=comp.1_em), color='red') + 
	geom_line(aes(y=comp.2_em), color='green') + 
	geom_line(aes(y=comp.1_mh), color='red', lty='dashed') + 
	geom_line(aes(y=comp.2_mh), color='green', lty='dashed') + 
	labs(color='Posterior Probability\nof Being in Composition 1')
# ------------------------------------------------------------------------
