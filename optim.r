# -------------------
# Set up R
rm(list=ls())
library(data.table)
library(ggplot2)
library(gridExtra)
# -------------------


# -------------------------------------------------
# Example 1: minimizing a basic function with optim

# define a function using a quadratic equation
quadraticFunction = function(x) { 
	y = 5 + 2*x + 3*x^2
	return(y)
}

# display what it looks like
ggplot(data.frame(x=0), aes(x=x)) + 
	stat_function(fun=quadraticFunction) + 
	xlim(-5, 5)
	
# use math to find the minimum
# ...uhhh I've forgotten everything before grad school

# use optim to find the minimum
solution = optim(0, quadraticFunction)

# graph the solution it found to confirm
ggplot(data.frame(x=0), aes(x=x)) + 
	stat_function(fun=quadraticFunction) + 
	geom_point(aes(y=solution$value, x=solution$par), size=5, color='red') + 
	xlim(-5, 5)
# -------------------------------------------------


# ------------------------------------------------------
# Example 2: linear regression with optim

# make some fake data
N=100
dt = data.table(x=seq(N), z=runif(N, 0, 100))
e = rnorm(N, 0, 50)

# make a fake outcome variable with known coefficients
dt[, y:=5 + 2*x + -3*z + e]

# display the data
p1 = ggplot(dt, aes(y=y,x=x)) + geom_point() 
p2 = ggplot(dt, aes(y=y,x=z)) + geom_point()
grid.arrange(p1,p2)

# use lm to find the coefficients
lmFit = lm(y~x+z, dt)

# use optim to find the coefficients
olsFunction = function(coefs, data) { 
	modelMatrix = cbind(1, as.matrix(data[,-'y']))
	yhat = modelMatrix%*%coefs
	rmse = sqrt(mean((data$y-yhat)^2))
	return(rmse)
}
solution = optim(par=c(0,0,0), fn=olsFunction, data=dt)

# compare coefficients
solution$par
lmFit$coef
# ------------------------------------------------------


# ------------------------------------------------------
# Optim for maximum likelihood estimation (poisson regression)

# N
n_obs <- 10000

# make x variables
x1 <- runif(n_obs, 0, 1)
x2 <- runif(n_obs, 0, 1)

# parameters for y
b0 <- 0
b1 <- 1
b2 <- 2
t <- round(runif(n_obs, 1, 1), 0)
l <- exp(b0 + b1*x1 + b2*x2)

# make y
y <- rpois(n_obs, t*l)

# define function to substitute the systematic component in for lambda
poisson_likelihood <- function(betas, y, x1, x2, t) {
	b0 <- betas[1]
	b1 <- betas[2]
	b2 <- betas[3]
	l <- exp(b0 + b1*x1 + b2*x2)
	log_likelihood <- sum(y * log(l*t) - l*t)
	return(-log_likelihood)
}

# define arbitrary initial values
initial_values <- c(1, 1, 1)

# find best betas
max_likelihood_estimate <- optim(initial_values, poisson_likelihood, y=y, x1=x1, x2=x2, t=t, hessian=TRUE)
inv_hessian <- solve(max_likelihood_estimate$hessian)
max_likelihood_estimate$par

# get uncertainty from the hessian matrix
sqrt(diag(inv_hessian))

# check against glm
summary(glm(y~x1+x2, family='poisson'))
# ------------------------------------------------------
