# ----------------------------------------------
# David Phillips
#
# 1/25/2017
# Template for a typical standalone function
# Inputs:
# x - some input argument
# y - some other input argument
# Outputs:
# out - something that the function returns
# ----------------------------------------------


# start function
myFunc <- function(x=NULL, y=NULL) {

	# test inputs 
	test1 <- class(x)!='character'
	test2 <- class(y)!='character'
	if (FALSE %in% c(test1, test2)) stop('One of the inputs has the wrong class!')

	# 

}
