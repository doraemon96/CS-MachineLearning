# KFold Script - Soncini Nicolas 2018
#
# This script takes a data file and creates a k-fold partition
# of it to be used for machine-learning purposes.
#
# Created for a Machine Learning class (UNR - Rosario,Argentina)

args = commandArgs(trailingOnly=TRUE)
if(length(args)==0){stop("Usage kfold <name> <K>")}

data_file <- args[1]
K <- as.integer(args[2])

# VARIABLES #


# SCRIPT #
d <- read.csv(data_file, header=FALSE)
d1 <- subset(d, d$V7 == 0)
d2 <- subset(d, d$V7 == 1)
ld1 <- length(d1[[1]])
ld2 <- length(d2[[1]])
# create a random access sequence
sd1 <- sample(1:ld1)
sd2 <- sample(1:ld2)
# calculate how many elements per fold
ed1 <- ld1 %/% K
ed2 <- ld2 %/% K
# generate the folds
for(fold in 0:(K-1)){
    print(paste("#Creating fold:",fold))
    
    output_file <- paste0(tools::file_path_sans_ext(data_file), "_", fold)

    ct1 <- fold*ed1 + 1
    ct2 <- fold*ed1 + ed1
    write.table(d1[sd1[ct1:ct2],], file=output_file, append=TRUE,
                row.names=FALSE, col.names=FALSE, sep=",")
    ct1 <- fold*ed2 + 1
    ct2 <- fold*ed2 + ed2
    write.table(d2[sd2[ct1:ct2],], file=output_file, append=TRUE,
                row.names=FALSE, col.names=FALSE, sep=",")

}
    
print(paste("#",(ld1+ld2) - ((ed1+ed2)*K),"elements remain"))
print("#Done")
