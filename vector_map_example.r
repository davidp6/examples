# --------------------------------------------------------------
# Author: Ellen Squires
# Date Created: May 18 2016 
# Description: Code for mapping exercise - Maputo Workshop 2016 
# --------------------------------------------------------------


# -------------------------------------------------------
# Set up R
rm(list=ls())

# load packages
library(ggplot2)
library(raster)

# set directory 
dir <- "C:/local/examples/"
setwd(dir)
# -------------------------------------------------------


# ---------------------------------------------------------------------
# Import data 

# load data 
vacdata <- fread("Province_Mapping_Starter_Dataset.csv")

# subset to just 1990 for mapping
vacdata <- vacdata[vacdata$year==1990,]
# ---------------------------------------------------------------------


# -------------------------------------------
# Import shapefile 

# load original shapefile
mapdata = shapefile('MOZ_adm1.shp')

# check if names match
unique(vacdata$province_name) %in% unique(mapdata@data$NAME_1)

# make sure all province names match
vacdata[province_name=='Niassa', province_name := 'Nassa']
vacdata = vacdata[province_name!='Cidade de Maputo']
vacdata[province_name=='Zamb‚zia', province_name := 'Zambezia']

# use the ggplot "fortify" function to convert the spatialpolygonsdataframe to a normal data frame
mapdata <- fortify(mapdata, region='NAME_1')
# -------------------------------------------


# --------------------------------------------------------------------
# Merge the datasets 

# merge the data 
plotdata <- merge(mapdata, vacdata, by.x="id", by.y="province_name", all.x=TRUE)
# --------------------------------------------------------------------


# ---------------------------------------------------------------------
# Make a basic map 

# most basic map
ggplot(plotdata, aes(x=long, y=lat, group=group)) + # generates empty grid
geom_polygon(aes(fill=coverage)) # draws polygons
# ---------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Make a better map 

# settings - color 
mapColors = colorRampPalette(c('#FFEEDC', '#FAA61A', '#5BA7B1', '#2D358E', '#1C1D48'))
mapColors = mapColors(10)

# settings - make the scale 
scale_limits <- c(0, 1.0)
scale_breaks <- seq(0, 1.0, by=.2)
scale_labels <- c("0%", "20%", "40%", "60%", "80%", "100%")

# map coverage 
ggplot(data=plotdata, aes(x=long, y=lat, group=group)) + # generates empty grid, sets default dataset for plotting
  geom_polygon(aes(fill=coverage)) + # overlays map on top of grid
  theme_minimal(base_size=16)  +  # sets grid/background to white and sets base font size
  geom_path(color="grey95", size=.05) + # sets color for district borders
  coord_fixed(ratio=1) + # keep proper aspect ratio
  scale_x_continuous("", breaks = NULL) + scale_y_continuous("", breaks = NULL) + #Label axes & remove grid lines
  ggtitle("Mozambique, 3rd Dose Pentavalent, 1990") + #Map title
  scale_fill_gradientn(paste("Coverage"), colours=mapColors, na.value = "white", limits=scale_limits, breaks=scale_breaks, labels=scale_labels) # defines the color scale / legend 
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Make multiple maps

# reload the dataset
vacdata <- fread("Province_Mapping_Starter_Dataset.csv")

# go back and subset to two years
vacdata <- vacdata[vacdata$year %in% c(1990, 2010),]
vacdata[province_name=='Niassa', province_name := 'Nassa']
vacdata = vacdata[province_name!='Cidade de Maputo']
vacdata[province_name=='Zamb‚zia', province_name := 'Zambezia']

# merge the data again. this creates duplicates on purpose!
mapdata = shapefile('MOZ_adm1.shp')
mapdata <- fortify(mapdata, region='NAME_1')
plotdata <- merge(mapdata, vacdata, by.x="id", by.y="province_name")
# plotdata = plotdata[order(plotdata$order),] # this to fix "polygon tearing"

# now make side by side maps using ggplot
ggplot(data=plotdata, aes(x=long, y=lat, group=group)) +
geom_polygon(aes(fill=coverage)) + 
facet_wrap(~year) # the facet_wrap option for ggplot makes graphs side-by-side. you just enter a formula (~) and the variable you want to use to repeat the graphs
# ----------------------------------------------------------------------------
