library(data.table)
library(ggplot2)

dt = data.table(y=seq(5), x=letters[1:5], f=c('a','b'))

ggplot() + 
	geom_point(data=dt, aes(y=y,x=x)) + 
	geom_bar(data=dt, aes(y=y, x=x), stat='identity') + 
	facet_wrap(~f)