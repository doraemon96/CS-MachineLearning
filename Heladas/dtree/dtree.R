# SVM Script - Soncini Nicolas 2018
#
# This script takes a tenfold partitioned data file and creates 
# a configuration file to train a decision tree.
# All results are printed to a file with a TODO: format.
#
# Created for a Machine Learning class (UNR - Rosario,Argentina)

library(stringr) #(str_match)

## INPUT ##
# NameRoot will be completed with "_<fold>"
args = commandArgs(trailingOnly=TRUE)
if(length(args)!=2){stop("Usage dtree <name-root> <output-dir>")}

data_dir <- args[1]
output_dir <- args[2]

## VARIABLES ##
data_root <- basename(data_dir)
#dtree_dir <- paste0("")

## HELPER FUNCTIONS ##
dtree_train <- function(name){return(paste0("c4.5 -f",name,"-g -u"))}

create_train <- function(seq,test)
{
    system(paste("mv",paste0(data_root,".data"),paste0(data_root,".data.old"))) 
    for(fold in seq){
        fold_root <- paste0(data_root,"_",fold)
        f <- read.csv(fold_root,header=FALSE)         #ej: lee "heladas_0" (en formato svm)
        write.csv(f,file=paste0(data_root,".data"),append=TRUE,       #ej: escribe "heladas" (en formato svm)
                    row.names=FALSE,col.names=FALSE,quote=FALSE)
    }
    system(paste("cp",paste0(data_root,"_",test),paste0(data_root,".test")))
}

read_err <- function(fname){
    regex <- ".*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.]).*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.])"
    errorap <- c()
    testap <- c()
    con <- file(fname,"r")
    while(TRUE){
        line <- readLines(con, n=1)
        if(length(line) == 0) {break}
        m <- str_match(line, regex)
        errorap <- c(errorap,as.double(m[5]))
        
        line <- readLines(con, n=1)
        if(length(line) == 0) {break}
        m <- str_match(line, regex)
        testap <- c(testap, as.double(m[5]))
    }

    return(list(errorap,testap))
}


######################
##      SCRIPT      ##
######################

for(fold in 0:9){
    fold_dir <- paste0(data_dir,"_",fold)      #ej: "/.../heladas_0"
    fold_root <- paste0(data_root,"_",fold)    #ej: "heladas_0"

    system(paste("cp",fold_dir,output_dir))
    print(paste("Prepared file:",fold_root))
}
system(paste("cp",paste0(data_dir,".names"),"."))


## RUN DTREE ##
system("mv predic.out predic.out.old")
for(fold in 0:9){
    train <- seq(0,9)
    train <- train[train!=fold]
    create_train(train,fold)

    # Train the system
    system(paste("c4.5 -f",data_root,"-g -u | grep \"<<\" >> predic.out"))
}

err <- read_err("predic.out")

print("Train Accuracy | Test Accuracy")
print(err)
