# ----------------------------------------------
# David Phillips
#
# 3/30/2017
# Example data analysis
# ----------------------------------------------


# --------------------
# Set up R
rm(list=ls())
library(data.table)
library(reshape2)
library(stringr)
library(RColorBrewer)
library(ggplot2)
# --------------------

print('hello world!')

plot(seq(10), seq(10))

# ----------------------------------------------
# Parameters and settings

# some constant that I might want to fiddle with
k <- 10

# whether or not to do a certain thing
makeGraphs <- TRUE
# ----------------------------------------------


# ----------------------------------------------
# Files and directories

# data directory
dir <- 'C:/local/examples/'

# input file
inFile <- paste0(dir, 'fake_data.csv')

# output files
modelOutputFile <- paste0(dir, 'output.rdata')
graphFile <- paste0(dir, 'graphs.pdf')
# ----------------------------------------------


# ----------------------------------------------
# Load/prep data

# load
data <- fread(inFile)

# subset variables

# subset observations

# format variables


# reshape data


# make new variables

# ----------------------------------------------


# ---------------------------------
# Run analysis

# model formula
form <- as.formula('y ~ x + z')

# run model
glmOut <- glm(form, 'gaussian', data)

# predict fitted values
data[, pred:=predict(glmOut)]
# ---------------------------------


# ----------------------------------------------
# Graph

# colors
cols <- brewer.pal(6, 'Paired')

# store graph
p <- ggplot(data, aes(y=y, x=x, color=z)) +
	geom_point() +
	geom_line(aes(y=pred)) +
	scale_color_gradientn('Z', colors=cols) +
	theme_bw()
# ----------------------------------------------


# --------------------------------
# Save graphs
pdf(graphFile, height=6, width=9)
p
dev.off()
# --------------------------------
