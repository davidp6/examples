library(data.table)
data = data.table(muni=c('a','b','c','d'), cases=c(200,240,160,210), tx_seeking=c(.99,.8,.6,.5))
total=1000

adjustmentFormula = function(beta, data) data$cases/(data$tx_seeking*beta*(1-data$tx_seeking))

adjuster = function(beta, data, total) { 
	adjustedCases = adjustmentFormula(beta, data)
	return(sqrt((sum(adjustedCases)-total)^2))
}

est = optim(.1, adjuster, gr='BFGS', data, total)

data[, adjustedCases :=  adjustmentFormula(est$par, data)]
data[, factor:=adjustedCases/cases]
data
