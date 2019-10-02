# ------------------------------------------------------------------------
# David Phillips
# 
# 110/2/2019
# Example of how to display regression coefficients with interaction terms
# ------------------------------------------------------------------------


# --------------------
# Set up R
rm(list=ls())
library(data.table)
library(ggplot2)
# --------------------


# ----------------------------------------------
# Load/prep data

# load the mtcars example data
data(mtcars)
# ----------------------------------------------


# ----------------------------------------------
# Display relationships being modelled

# display primary relationship
# there's a clear negative "effect" of weight on MPG
ggplot(mtcars, aes(y=mpg, x=wt)) + 
	geom_point() + 
	geom_smooth(method='lm')
	
# there's also an interaction between number of cylinders and the effect of weight on MPG
# (i.e. the slope of the line is different in each panel)
ggplot(mtcars, aes(y=mpg, x=wt)) + 
	geom_point() + 
	geom_smooth(method='lm') + 
	facet_wrap(~cyl, scales='free_x')
# ----------------------------------------------


# ----------------------------------------------------------------------------
# Use interaction term to measure how the slope of the line changes at different levels of cyl
# Note: this is demonstrating a regression without a "main effect" of cyl on mpg, that's less normal than
# one that has a main effect, which would be signified by * instead of :

# model formula
form = as.formula('mpg ~ wt + wt:cyl')

# run model
fit = lm(form, mtcars)

# summarize
summary(fit)

# beta 1 is the effect of wt on mpg when cyl is zero (imaginary cars with no cylinders)
# "for zero-cylinder cars, every extra unit of wt (1000 pounds) causes mpg to go down by 1.7"
coef(fit)[2]

# beta 1 plus beta 2*mean(cyl) is the effect of wt on mpg for a normal level of cyl
# "for 6-cylinder cars, every extra unit of wt causes mpg to go down by 3.8"
coef(fit)[2] + coef(fit)[3]*mean(mtcars$cyl)
# ----------------------------------------------------------------------------
