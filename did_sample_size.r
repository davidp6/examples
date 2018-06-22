# simulate sample sizes for DiD

# set up R
rm(list=ls())
library(data.table)
library(ggplot2)

# assumptions
p0 = .27 # prevalence at baseline in treatment arm
p1 = .18 # prevalence post-intervention in treatment arm
beta = 0 # secular trend
sigma = .05 # residual sd

# inputs
a = .95 # confidence
b = .05 # power

# function to compute one-arm sample size
calc = function(a=NULL, b=NULL, p0=NULL, p1=NULL) { 
	n = ((qnorm(1-((1-a)/2)) + qnorm(1-b))^2) * (p1*(1-p1) + (p0*(1-p0))) / (p1-p0)^2
	n = round(n)
	return(n)
}

# get treatment arm size to start sims
N = calc(a, b, p0, p1)

# function to simulate data (assuming equal sample sizes before and after intervention and identical prevalence between the two arms at baseline)
sim = function(N1=NULL, N2=NULL, p0=NULL, p1=NULL, beta=NULL, sigma=NULL) { 
	data = data.table(treatment=rep(c(0,1), each=N1+N2), post_intervention=rep(c(0,1), N1+N2))
	e = rnorm(N1+N2, 0, sigma)
	data[, y := p0 + (p1-p0)*treatment*post_intervention + 0*treatment + beta*post_intervention + e]
	return(data)
}

# check function
# data = sim(N, N, p0, p1, beta, sigma)
# ggplot(data, aes(y=y, x=factor(post_intervention), group=factor(post_intervention))) + geom_boxplot() + facet_wrap(~treatment)

# simulate
simData = expand.grid(N1=seq(2, 30, by=1), N2=seq(2, 30, by=1))
ests = sapply(seq(nrow(simData)), function(x) { 
	# simulate data
	data = sim(simData[x,1], simData[x,2], p0, p1, beta, sigma) 

	# compute effect size confidence and power
	lmFit = lm(y~treatment*post_intervention + treatment + post_intervention, data)
	a_hat = summary(lmFit)$coefficients[,4]['treatment:post_intervention']
	# b_hat = (p1*(1-p1))*((qnorm(1-((1-a)/2)) + qnorm(1-b))^2) / ((p1-p0)^2 - (p0*(1-p0))*((qnorm(1-((1-a)/2)) + qnorm(1-b))^2))
	return(a_hat)
} )
simData = data.table(simData, ests)
ggplot(simData, aes(y=N2, x=N1, fill=ests)) + geom_tile()

# 
r = seq(0.01,.99,.01)
ests = sapply(r, function(x) { 
	n = diggle.linear.power(d=(p1-p0), t=c(0,1), R=x, sig.level=0.05, power=0.95)
	n = n$n
	return(n)
})
cbind(r, ests)
