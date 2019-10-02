# -------------------------------------------------------
# Example of map-making
# -------------------------------------------------------


# -------------------------------------------------------
# Set up R
rm(list=ls())

# load packages
library(raster) # the raster package is great for all types of map-making functions
library(ggplot2) # ggplot for making the graphics
library(RColorBrewer) # this package has nice colors, might need to install.packages('RColorBrewer')

# set directory 
dir <- "C:/File Path to Data/"
setwd(dir)
# -------------------------------------------------------


# ---------------------------------------------------------------------
# Import vaccine data 

# load data 
data <- read.csv("Data for Map.csv", header=TRUE)

# perform whatever computation you need
# ---------------------------------------------------------------------


# --------------------------------------
# Subset data 

# subset to just one variable
subset <- data[data$variable=='SOME VARIABLE NAME',]

# make other subsets that you need
# --------------------------------------


# --------------------------------------------------------------------------
# Import shapefile 

# import shapefile (this one is stored as an rdata file type)
shapedata <- load("hz_shapefile.rds")

# convert the shapefile to a data frame
shapedata_df <- fortify(shapedata, region='index')

# merge the names of the health zones to the fortified data frame
shapedata_df <- merge(shapedata_df, shapedata@data, by.x='id', by.y='index')
# --------------------------------------------------------------------------


# --------------------------------------------------------------------------------------
# Merge the datasets 

# merge the data to the shape data
plotdata <- merge(shapedata_df, subset, by.x="Name", by.y="health_zone", all.x=TRUE)
# --------------------------------------------------------------------------------------


# ---------------------------------------------------------------------
# Make a basic map 

# get nicer colors for map
mapColors = brewer.pal(10, 'RdYlBu')

# most basic map
ggplot(plotdata, aes(x=long, y=lat, group=group, fill=VALUE_VARIABLE_NAME)) + # generates empty grid
	geom_polygon() + # this fills in the areas with colors
	geom_path(color='grey65', size=.05) + # this draws the borders
	scale_fill_gradientn(paste('Legend Title'), colours=mapColors, na.value='white') + # apply nicer colors
	theme_void() # this removes the axes
	
# if you need a log scale, do this instead of line 70:
# scale_fill_gradientn(paste('Legend Title'), colours=mapColors, na.value='white', trans='log', breaks=c(100, 1000, 10000, 100000))
# ---------------------------------------------------------------------
