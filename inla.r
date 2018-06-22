install.packages("INLA", repos="https://inla.r-inla-download.org/R/stable")
library(INLA)

data(Epil)
my.center = function(x) (x - mean(x))

## make centered covariates
Epil$CTrt    = my.center(Epil$Trt)
Epil$ClBase4 = my.center(log(Epil$Base/4))
Epil$CV4     = my.center(Epil$V4)
Epil$ClAge   = my.center(log(Epil$Age))
Epil$CBT     = my.center(Epil$Trt*Epil$ClBase4)

## Define link function for fitted values
link = rep(NA, nrow(Epil))
link[which(is.na(Epil$y))] = 1

##Define the model
formula = y ~ ClBase4 + CTrt + CBT+ ClAge + CV4 +
          f(Ind, model="iid") + f(rand,model="iid")

result = inla(formula,family="poisson", data = Epil, control.predictor = list(link = link))
summary(result)
plot(result)

## Provide improved estimates for the hyperparameters
hyper = inla.hyperpar(result)
summary(hyper)
plot(hyper)