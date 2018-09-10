# script 1: a function that sources a script
fn <- function(x) { 
	print(paste('This is from script 1:', x))
	source('./script2.r', local=TRUE)
}
