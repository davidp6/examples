# Example of using R in parallel on the cluster
# This is script2, which is executed by script1 via a shell script
# handle incoming argument (arguments 1-3 are system variables)
j <- commandArgs()[4]
# do something with argument
print(j)
write.csv(j, paste0('./output', j, '.csv'))
