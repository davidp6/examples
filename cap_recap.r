# define parameters
set.seed(1)
N = 250 # true size of population
n1 = 80 # size of sample 1
n2 = 80 # size of sample 2
ntrials = 1000 # number of repetitions

# create population
pop = seq(N)

# run capture-recapture `ntrials' times
trials = sapply(seq(ntrials), function(i) {
	s1 = sample(pop, n1)
	s2 = sample(pop, n2)
	s2[s2 %in% s1]

	r = length(s2[s2 %in% s1])/(length(s2))
	N_hat = length(s1)/r
	N_hat
})

# display results
head(trials)
mean(trials[is.finite(trials)])
N

