# making bar charts like the upshot using ggplot
# example: https://www.nytimes.com/2017/06/13/upshot/what-an-algorithm-reveals-about-life-on-chicagos-high-risk-list.html

# set up R
rm(list=ls())
library(data.table)
library(ggplot2)
library(RColorBrewer)

# set up fake data
data = data.table(group=rep(c('Group 1', 'Group 2'), each=10), category=rep(LETTERS[1:10],2), value=runif(20, 0, 100))
data[value>=1, lab:=paste0(round(value), '%')]
data[value<1, lab:=paste0(round(value,1), '%')]

# set up to graph
fillColors = c(brewer.pal(8, 'BuPu')[8], brewer.pal(8, 'GnBu')[8])

# graph
ggplot(data, aes(x=category, y=value, fill=group)) + 
	geom_bar(aes(y=rep(max(data$value), nrow(data))), stat='identity', fill='#EBF5EE') + 
	geom_bar(stat='identity') + 
	geom_text(data=data[value>=10], aes(label=lab), hjust=1.25, color='grey90', fontface='bold') + 
	geom_text(data=data[value<10], aes(label=lab), hjust=-.25, color='grey10') + 
	coord_flip() + 
	facet_wrap(~group, ncol=2) + 
	scale_fill_manual('', values=fillColors) + 
	labs(title='Percent of Something', y='', x='') +
	theme_minimal() + 
	theme(axis.title.x=element_blank(), axis.text.x=element_blank(), 
		axis.ticks.x=element_blank(), panel.grid = element_blank(), legend.position='none')
