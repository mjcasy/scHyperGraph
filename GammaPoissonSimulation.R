

library(reticulate)
library(Matrix)
source("./3clusters.R")

N <- 300
G <- 1800
Trials <- 100

Results <- matrix(nrow = 3*Trials, ncol = 3)

set.seed(1)
k <- 1
for(i in 1:Trials){
  
  for(j in 1:3){
    if(j == 1){
      CountsMatrix <- One_Cluster(N, G)
    } else if(j ==2){
      CountsMatrix <- Two_Clusters(N, G)
    } else {
      CountsMatrix <- Three_Clusters(N, G)
    }
    
    Results[k,3] <- j
    
    py_run_file("./HyperEigen.py")
    Results[k,1] <- as.numeric(py$large_val)
    
    tCounts <- apply(CountsMatrix, 2, function(x) x / sum(x))
    CountsMatrix <- asSparseMatrix(tCounts)
    
    py_run_file("./HyperEigen.py")
    Results[k,2] <- as.numeric(py$large_val)
    k <- k+1
  }
}

# save(Results, file = "GamPoiSim")
# load("GamPoiSim")
tapply(Results[,1], Results[,3], mean)
tapply(Results[,1], Results[,3], sd)

tapply(Results[,2], Results[,3], mean)
tapply(Results[,2], Results[,3], sd)

plot(Results[,3], Results[,1])
plot(Results[,3], Results[,2])
  
cor.test(Results[,3], Results[,1], "two.sided", "spearman", exact = FALSE)
cor.test(Results[,3], Results[,2], "two.sided", "spearman", exact = FALSE)

