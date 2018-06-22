# speed tests for R 3.4.0 vs 3.2.0
# http://www.i-programmer.info/news/98-languages/10723-r-34-brings-performance-improvements.html

# linear algebra
n = 10000
m1 = matrix(runif(n*100, 0, 1), ncol=n/100)
m2 = matrix(runif(n*100, 0, 1), nrow=n/100)
lat = proc.time()
m3 = m1 %*% m2
lat = proc.time() - lat
lat

# accumulating a loop in a vector
n = 100000
v = 0
vt = proc.time()
for(i in seq(n)) v = c(v, i)
vt = proc.time() - vt
vt

# sorting a vector
n = 10000000
v = runif(n, 0, 1)
st = proc.time()
v = v[order(v)]
st = proc.time() - st
st
