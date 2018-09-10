# --------------------
# Set up R
rm(list=ls())
library(data.table)
library(ggplot2)
# --------------------


# ---------------------------------------------------------------------------------------
# Make fake data

# random numbers as income
income = runif(100,0,100)

# outcome pre-intervention as a simple function of income and some random noise
# just choosing arbitrary numbers as the coefficients here...
outcome_pre = 1 + .5*income + rnorm(100,0,5)

# identify who is in the intervention category
intervention = income<50

# make outcome post intervention if the intervention only affects the intercept
outcome_post_int = 2 + .5*income + -30*intervention + rnorm(100,0,5)

# make outcome post intervention if the intervention also affects the slope
outcome_post = 2 + .5*income + -10*intervention + -1*income*intervention + rnorm(100,0,5)
# ---------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Assemble data into a data.table for convenience

# pre-intervention
data_pre = data.table(outcome_post_int=outcome_pre, income, intervention=FALSE, time=0)

# post-intervention
data = data.table(outcome_post_int, outcome_post, income, intervention, time=1)

# append
data= rbind(data, data_pre, fill=TRUE)
# -----------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
# Run regressions

# regression on intercept-only scenario
fit_int = lm(outcome_post_int~income+intervention, data[time==1])

# check the output
summary(fit_int)

# regression on the intercept and slope scenario
fit = lm(outcome_post~income+intervention+income*intervention, data[time==1])

# check the output
summary(fit)

# regression on the intercept-only scenario that accounts for pre-intervention data
fit_time = lm(outcome_post_int~income+intervention+income*time+intervention*time, data)

# check the output
summary(fit_time)

# predict fitted valeus for each
data[time==1, pred_post_int:=predict(fit_int)]
data[time==1, pred_post:=predict(fit)]
data[, pred_time:=predict(fit_time)]
# --------------------------------------------------------------------------------------




# -----------------------------------------------------------------------------
# Graph the results

# intercept-only scenario
ggplot(data[time==1], aes(y=outcome_post_int, x=income, shape=intervention)) + 
	geom_point() + 
	geom_line(aes(y=pred_post_int))
	
# intercept and slope scenario
ggplot(data[time==1], aes(y=outcome_post, x=income, shape=intervention)) + 
	geom_point() + 
	geom_line(aes(y=pred_post))

# intercept-only scenario with pre-intervention
ggplot(data, aes(y=outcome_post_int, x=income, shape=intervention, color=factor(time))) + 
	geom_point() + 
	geom_line(aes(y=pred_time))
# -----------------------------------------------------------------------------
