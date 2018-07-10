# SVM Script - Soncini Nicolas 2018
#
# This script takes a tenfold partitioned data file and creates 
# a configuration file to be used to train a support vector machine.
# All results are printed to a file with a TODO format.
#
# Created for a Machine Learning class (UNR - Rosario,Argentina)

library(stringr) #(str_match)

## INPUT ##
# NameRoot will be completed with "_<fold>"
args = commandArgs(trailingOnly=TRUE)
if(length(args)!=2){stop("Usage svm <name-root> <output-dir>")}

data_dir <- args[1]
output_dir <- args[2]

## VARIABLES ##
C_list <- seq(from=1e-2,to=20,by=0.1999)  #List of C's to use

data_root <- basename(data_dir)
svm_dir <- paste0("./libsvm-3.22/")
svm_train <- paste0(svm_dir,"svm-train")
svm_predict <- paste0(svm_dir,"svm-predict")

## HELPER FUNCTIONS ##
create_train <- function(seq)
{
    system(paste("mv",data_root,paste0(data_root,".old"))) 
    for(fold in seq){
        fold_root <- paste0(data_root,"_",fold)
        f <- read.table(fold_root,header=FALSE)         #ej: lee "heladas_0" (en formato svm)
        write.table(f,file=data_root,append=TRUE,       #ej: escribe "heladas" (en formato svm)
                    row.names=FALSE,col.names=FALSE,quote=FALSE)
    }
}

read_acc <- function(fname){
    regex <- ".*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.])"

    r <- readLines(fname)
    if(length(r) == 0){break}
    m <- str_match(r,regex)

    return(as.double(m[2]))
}

######################
##      SCRIPT      ##
######################

## PREPARE DATA ##
for(fold in 0:9){
    fold_dir <- paste0(data_dir,"_",fold)      #ej: "/.../heladas_0"
    fold_root <- paste0(data_root,"_",fold)    #ej: "heladas_0"

    system(paste("mv",fold_root,paste0(fold_root,".old")))

    #Indexes all columns except the first (libsvm format)
    f <- read.csv(fold_dir,header=FALSE)
    d <- c(f[,7])
    for(col in seq(1,6)){
        d <- c(d,paste0(col,":",f[,col]))
    }
    dim(d) <- c(length(f[[1]]),7)

    #Write as table (libsvm format)
    write.table(d, file=fold_root,append=TRUE,
                row.names=FALSE,col.names=FALSE,quote=FALSE)
    print(paste("Prepared file:",fold_root))
}


## ADJUST SVM PARAMS ##
train <- 1:9
test_fold <- paste0(data_root,"_",0)
create_train(train)

opt_C <- -1
opt_acc <- 0
test_acc <- c()
train_acc <- c()
for(C in C_list){
    # Train the system with different C's
    system(paste(svm_train,"-c",C,data_root))

    # Predict training folds for training error
    system(paste(svm_predict,data_root,paste0(data_root,".model"),"/dev/null",">>","predic.out"))
    train_acc <- c(train_acc, read_acc("predic.out"))
    #system(paste("rm predic.out"))
    system(paste("mv predic.out predic.old"))

    # Predict test fold for test error
    system(paste(svm_predict,test_fold,paste0(data_root,".model"),"/dev/null",">>","predic.out"))
    test_acc <- c(test_acc, read_acc("predic.out"))
    #system(paste("rm predic.out"))
    system(paste("mv predic.out predic.old"))

    if(test_acc[length(test_acc)] > opt_acc){
        opt_acc <- test_acc[length(test_acc)]
        opt_C   <- C
    }
}

print("C | Train Accuracy | Test Accuracy")
print(C_list)
print(train_acc)
print(test_acc)
print(paste("Opt C:",opt_C,", Accuracy:",opt_acc))


## RUN SVM ##
train_acc <- c()
test_acc <- c()
for(fold in 1:9){
    train <- seq(0,9)
    train <- train[train!=fold]
    create_train(train)
    test_fold <- paste0(data_root,"_",fold)

    # Train the system with optimal C
    system(paste(svm_train,"-c",opt_C,data_root))

    # Predict training folds for training error
    system(paste(svm_predict,data_root,paste0(data_root,".model"),"/dev/null",">>","predic.out"))
    train_acc <- c(train_acc, read_acc("predic.out"))
    #system(paste("rm predic.out"))
    system(paste("mv predic.out predic.old"))

    # Predict test fold for test error
    system(paste(svm_predict,test_fold,paste0(data_root,".model"),"/dev/null",">>","predic.out"))
    test_acc <- c(test_acc, read_acc("predic.out"))
    #system(paste("rm predic.out"))
    system(paste("mv predic.out predic.old"))
}

print("Train Accuracy | Test Accuracy")
print(train_acc)
print(test_acc)
