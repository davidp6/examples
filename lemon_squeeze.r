# test lemon squeezing
set.seed(1)
library(car)
N=1000
prop = round(runif(N,0,1),1)


# transform to open interval
prop_t = (( prop * (N-1)) + 0.5) / N
table(prop)
table(prop_t)

# logit() from car will remap 0 and 1 to .025 and .975
logit = logit(prop)

# lemon-sequeeze
ls = logit(prop_t)

# plot
hist(logit)
hist(ls)
