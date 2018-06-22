
# raster package is most of what you need
library(data.table)
library(rgeos)
library(raster)
library(ggplot2)

# change directory
setwd('J:/Project/Evaluation/GF/mapping/gtm/')

# load the shapefile
shapeData = shapefile('GTM_munis_only.shp')

# shapeData is a spatialpolygonsdataframe
class(shapeData)

# these have plot methods
plot(shapeData)

# simplify the shape data (could create little gaps, maybe don't do this)
shapeData2 = gSimplify(shapeData, tol=0.1, topologyPreserve=TRUE)

# use the fortify function to convert from spatialpolygonsdataframe to data.frame
coordinates = data.table(fortify(shapeData2, region='ID_2')) # use IDs instead of names

# merge on municipality names
names = data.table(shapeData@data)
coordinates = merge(coordinates, names, by.x='id', by.y='ID_2')


# merge on the data (all.x=TRUE so the shapefile data doesn't disappear)




# draw the polygons using ggplot2
ggplot(coordinates, aes(x=long, y=lat, group=group, fill=as.numeric(id))) + 
	geom_polygon() + 
	geom_path() + 
	theme_void()
	
	
