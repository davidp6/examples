library(sp)
library(automap)
library(ggplot2)
library(data.table)

# make data
x = seq(10)
y = c(1,3,5,6,1.5,2.5,4.5,.5,3.5,1)
Response = c(25, 23, 23, 19, 55, 50, 48, 78, 72, 100)
data = data.table(x,y,Response)

# graph points
ggplot(data=data, aes(x=x, y=y, color=Response)) + 
	geom_point(size=4.5) + 
	theme_minimal(base_size=16)

# dumb interpolation for viz
pred_frame = data.table(expand.grid(x=seq(1, 10, by=1), y=seq(1, 10, by=1)))
lmFit = lm(Response~x*y, data)
pred_frame[, pred:=predict(lmFit, newData=pred_frame)]
	
# graph interpolation
ggplot(data=pred_frame, aes(x=x, y=y, fill=pred)) + 
	geom_tile() + 
	theme_minimal(base_size=16)

	
	
	
# krig
data = data.frame(x,y,Response)
spdf <- SpatialPointsDataFrame(coords = data[,c('x','y')], data = data,
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
pred_frame = expand.grid(x=seq(1, 10, by=.1), y=seq(1, 10, by=.1))
spdf_pred <- SpatialPointsDataFrame(coords = pred_frame[,c('x','y')], data = pred_frame,
					   proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
					   
autoKrige(Response~x+y, spdf, spdf_pred)
