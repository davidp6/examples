# -----------------------------------------------------------------
# David Phillips
#
# 12/13/2017
# Example of working with raster (pixel) and vector (polygon) data
# -----------------------------------------------------------------


# to do
# make district aggregation population-weighted

# --------------------
# Set up R
rm(list=ls())
library(data.table)
library(raster)
library(ggplot2)
library(raster)
library(rgdal)
library(rgeos)
# --------------------


# ----------------------------------------------------------------------------
# Files and directories

# raster file
rasterFile = 'LOCATION OF DATA/Uganda 1km Poverty/uga11povmpi.tif'

# shapefile of district borders
vectorFile = 'LOCATION OF DATA/uga_dist112_map.shp'

# district-level estimates of something
distFile = 'LOCATION OF DATA/dpt3_cov_binomial_car_spline_source_preds.rdata'
# ----------------------------------------------------------------------------


# ---------------------------------
# Load data

# load raster data
rasterData = raster(rasterFile)

# load shapefile data
vectorData = shapefile(vectorFile)

# load district-level estimates 
# (puts an object called "preds" in memory)
load(distFile)
# ---------------------------------


# -------------------------------------------------------------------------------
# Aggregate pixels to polygons and merge estimates together

# aggregate to ditrict level
aggRaster = extract(rasterData, vectorData)

# aggregate to district level (would be better if population-weighted)
aggRaster = data.table(do.call('rbind',lapply(aggRaster, mean, na.rm=TRUE)))
aggRaster[,dist112:=as.character(vectorData@data[,'dist112'])]

# format district estimates for merge
preds = data.table(preds)
preds = preds[level=='dist112']
preds[, area:=as.character(area)]

# merge to district-level estimates
dataDist = merge(aggRaster, preds, by.x='dist112',by.y='area',all=TRUE)
# -------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------
# Set up to graph

# colors
cols = rev(c('#009392','#39b185','#9ccb86','#e9e29c','#eeb479','#e88471','#cf597e'))
border = 'grey65'

# merge district level data to shapedata
graphData = data.table(fortify(vectorData, region='dist112'))
graphData = merge(graphData, dataDist[t==2016, c('dist112','V1', 'mean'), with=FALSE], by.x='id', by.y='dist112')

# reshape long
graphData = melt(graphData, id.vars=c('id', 'long', 'lat', 'order', 'hole', 'piece', 'group'))
graphData[variable=='V1', variable:='Poverty']
graphData[variable=='mean', variable:='Coverage']
# ----------------------------------------------------------------------------------


# ----------------------------------------------------------------------
# Map
ggplot(graphData, aes(x=long, y=lat, group=group, fill=value)) + 
	geom_polygon() + 
	geom_path(color=border, size=.05) + 
	scale_fill_gradientn('%', colors=cols, na.value='white') + 
	facet_wrap(~variable) + 
	labs(title='Multidimensional Poverty Index vs Vaccine Coverage') + 
	scale_x_continuous('', breaks = NULL) + 
	scale_y_continuous('', breaks = NULL) + 
	theme_minimal(base_size=16) + 
	theme(plot.title=element_text(hjust=.5)) 
# ----------------------------------------------------------------------


