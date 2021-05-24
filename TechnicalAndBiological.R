
library(Matrix)
library(reticulate)

DataSets <- list(Path2Svensson, Path2Tian, Path2Stumpf)

Results <- matrix(NA, nrow = length(DataSets), ncol = 2)
dimnames(Results) <- list(c("Svensson", "Tian", "Stumpf"), c("Model 1", "Model 2"))

for(i in 1:nrow(Results)){
  for(j in 1:ncol(Results)){
    load(DataSets[[i]])
    CountsMatrix <- t(CountsMatrix)
    
    if (j == 2){
      CountsMatrix <- t(t(CountsMatrix) / colSums(CountsMatrix))
    }

    py_run_file("./HyperEigen.py")

    Results[i,j] <- signif(as.numeric(py$large_val), 3)
    rm(CountsMatrix)
    print(Sys.time())
  }
}
