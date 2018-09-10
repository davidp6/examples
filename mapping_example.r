# -------------------------------------------------------
# Example of map-making
# -------------------------------------------------------


# -------------------------------------------------------
# Set up R
rm(list=ls())

# load packages
library(raster) # the raster package is great for all types of map-making functions
library(ggplot2) # ggplot for making the graphics

# set directory 
dir <- "C:/Fake File Path to Data/"
setwd(dir)
# -------------------------------------------------------


# ---------------------------------------------------------------------
# Import vaccine data 

# load data 
vacdata <- read.csv("Data for Map.csv", header=TRUE)

# perform whatever computation you need
# ---------------------------------------------------------------------


# --------------------------------------
# Subset data 

# subset to just 1990 for mapping
vacdata <- vacdata[vacdata$year==1990,]

# look at it
vacdata
# --------------------------------------


# -------------------------------------------
# Import shapefile 

# import shapefile
load("moz_prov_map.rdata")

# which variables are in the shapefile?
head(mapdata)

# how many unique values of "id" are there? 
unique(mapdata$id)
# -------------------------------------------


# --------------------------------------------------------------------
# Merge the datasets 

# merge the data 
plotdata <- merge(mapdata, vacdata, by.x="id", by.y="province_number")
# --------------------------------------------------------------------


# ---------------------------------------------------------------------
# Make a basic map 

# most basic map
ggplot(plotdata, aes(x=long, y=lat, group=group)) + # generates empty grid
geom_polygon(aes(fill=coverage)) # draws polygons
# ---------------------------------------------------------------------
