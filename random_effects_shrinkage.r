library(lme4)
library(data.table)
library(ggplot2)

fm1 <- lmer(Reaction ~ (1 | Subject), sleepstudy)
ff1 <- lm(Reaction ~ factor(Subject), sleepstudy)

ranef(fm1)
summary(ff1)

re = data.frame(ranef(fm1)[[1]])+mean(sleepstudy$Reaction)
ff = coef(ff1)[2:length(coef(ff1))]
ff = c(coef(ff1)[1], ff+coef(ff1)[1])

comp = data.table('Random Effects'=re[[1]], 'Fixed Effects'=ff)

dt = data.table(sleepstudy)
mean = dt[, list(Mean=mean(Reaction)), by='Subject']


comp = cbind(mean, comp)
comp = melt(comp, id.var='Subject')

ggplot(comp, aes(x=Subject, y=value, color=variable, shape=variable)) + 
	geom_point(size=2) + 
	geom_hline(aes(yintercept=mean(sleepstudy$Reaction))) + 
	annotate('text', label='Global Mean',y=mean(sleepstudy$Reaction), x='310', vjust=1) + 
	scale_shape_discrete(name='Estimator') + 
	scale_color_discrete(name='Estimator') + 
	labs(title='Comparison of Random Effects and Fixed Effects', caption='Random effect estimates are shrunk towards the global mean')
