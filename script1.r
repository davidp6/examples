# Example of using R in parallel on the cluster
# This is script1, which executes script2 via a shell script
# loop over jobs
for(j in seq(10)) {
# store qsub command
qsub <- paste0('qsub -e . -o . -cwd -P proj_cod -N job', j, ' ./r_shell.sh ./script2.r ', j)

# submit job
system(qsub)
}
