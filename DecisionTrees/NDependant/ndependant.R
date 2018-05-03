# Machine Learning Script (assignment 1.5)
# Nicolas Soncini - 2018

library(stringr)
options(digits=5)

n <- c(125,250,500,1000,2000,4000)

d_training_error_bp <- c()
d_test_error_bp <- c()
d_nodes_bp <- c()
d_training_error_ap <- c()
d_test_error_ap <- c()
d_nodes_ap <- c()

for (i in n){
  dir <- paste0("Diag", i, "Ds/")
  fname <- paste0(dir,"diag",toString(i)) #ie: Diag125Ds/diag125
  oname <- paste0(fname, ".out") #ie: Diag125Ds/diag125.out
  
  system(paste("mv", oname, paste0(oname, ".old")))
  for (j in 1:20){
    dname <- paste0(fname, "_", toString(j)) #ie: diag125_1
    
    # Run C4.5, redirect interesting output to <fname>.out
    cmd <- paste("c4.5 -f", dname, "-g -u | grep \"<<\" >>", oname)
    system(cmd)
  }
  
  nodesbp <- 0
  errorbp <- 0
  testbp <- 0

  nodesap <- 0
  errorap <- 0
  testap <- 0

  # Run the Regular Expression to find the values
  # Regex: 1-NodesBP 2-ErrorBP 3-NodesAP 4-ErrorAP
  regex <- ".*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.]).*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.])"
  con <- file(oname, "r")
  while (TRUE) {
    line <- readLines(con, n=1)
    if(length(line) == 0) {break}
    m <- str_match(line, regex)
    nodesbp <- nodesbp + strtoi(m[2])
    errorbp <- errorbp + as.double(m[3])
    nodesap <- nodesap + strtoi(m[4])
    errorap <- errorap + as.double(m[5])
    
    line <- readLines(con, n=1)
    if(length(line) == 0) {break}
    m <- str_match(line, regex)
    testbp <- testbp + as.double(m[3])
    testap <- testap + as.double(m[5])
  }

  close(con)
  
  say <- paste("Diagonal: For n =", i, ": nodesbp (", nodesbp/20 ,") ; errorbp (", errorbp/20 ,") ; testbp (", testbp/20, ").")
  print(say)
  say <- paste("Diagonal: For n =", i, ": nodesap (", nodesap/20 ,") ; errorap (", errorap/20 ,") ; testap (", testap/20, ").")
  print(say)

  d_training_error_bp <- c(d_training_error_bp, errorbp/20)
  d_test_error_bp <- c(d_test_error_bp, testbp/20)
  d_nodes_bp <- c(d_nodes_bp, nodesbp/20)
  d_training_error_ap <- c(d_training_error_ap, errorap/20)
  d_test_error_ap <- c(d_test_error_ap, testap/20)
  d_nodes_ap <- c(d_nodes_ap, nodesap/20)
}

p_training_error_bp <- c()
p_test_error_bp <- c()
p_nodes_bp <- c()
p_training_error_ap <- c()
p_test_error_ap <- c()
p_nodes_ap <- c()

for (i in n){
  dir <- paste0("Par", i, "Ds/")
  fname <- paste0(dir,"par",toString(i)) #ie: Par125Ds/par125
  oname <- paste0(fname, ".out") #ie: par125Ds/par125.out
  
  system(paste("mv", oname, paste0(oname, ".old")))
  for (j in 1:20){
    dname <- paste0(fname, "_", toString(j)) #ie: par125_1
    
    # Run C4.5, redirect interesting output to <fname>.out
    cmd <- paste("c4.5 -f", dname, "-g -u | grep \"<<\" >>", oname)
    system(cmd)
  }
  
  nodesbp <- 0
  errorbp <- 0
  testbp <- 0

  nodesap <- 0
  errorap <- 0
  testap <- 0

  # Run the Regular Expression to find the values
  # Regex: 1-NodesBP 2-ErrorBP 3-NodesAP 4-ErrorAP
  regex <- ".*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.]).*?(\\d+).*?([+-]?\\d*\\.\\d+)(?![-+0-9\\.])"
  con <- file(oname, "r")
  while (TRUE) {
    line <- readLines(con, n=1)
    if(length(line) == 0) {break}
    m <- str_match(line, regex)
    nodesbp <- nodesbp + strtoi(m[2])
    errorbp <- errorbp + as.double(m[3])
    nodesap <- nodesap + strtoi(m[4])
    errorap <- errorap + as.double(m[5])
    
    line <- readLines(con, n=1)
    if(length(line) == 0) {break}
    m <- str_match(line, regex)
    testbp <- testbp + as.double(m[3])
    testap <- testap + as.double(m[5])
  }

  close(con)
  
  say <- paste("Parallel: For n =", i, ": nodesbp (", nodesbp/20 ,") ; errorbp (", errorbp/20 ,") ; testbp (", testbp/20, ").")
  print(say)
  say <- paste("Parallel: For n =", i, ": nodesap (", nodesap/20 ,") ; errorap (", errorap/20 ,") ; testap (", testap/20, ").")
  print(say)

  p_training_error_bp <- c(p_training_error_bp, errorbp/20)
  p_test_error_bp <- c(p_test_error_bp, testbp/20)
  p_nodes_bp <- c(p_nodes_bp, nodesbp/20)
  p_training_error_ap <- c(p_training_error_ap, errorap/20)
  p_test_error_ap <- c(p_test_error_ap, testap/20)
  p_nodes_ap <- c(p_nodes_ap, nodesap/20)
}

## PLOTTING ##
library(ggplot2)

# Before prunning training error and test error
png("errorbp.png")
limy <- c(min(d_training_error_bp,d_test_error_bp),max(d_training_error_bp,d_test_error_bp))
plot(n, d_training_error_bp, col="red", ylim=limy, type="o", xlab="Training points", ylab="Percentual error")
lines(n, d_test_error_bp, col="red", type="o", lty=3)
lines(n, p_training_error_bp, col="blue", type="o")
lines(n, p_test_error_bp, col="blue", type="o", lty=3)
legend(  x="topright",
       , legend=c("Diagonal train", "Diagonal test", "Parallel train", "Parallel test")
       , col=c("red", "red", "blue", "blue")
       , lty=c(1,3,1,3)
       )
dev.off()

# Before prunning node count
png("nodecbp.png")
limy <- c(min(p_nodes_bp, d_nodes_bp),max(p_nodes_bp,d_nodes_bp))
plot(n, d_nodes_bp, col="red", ylim=limy, type="o", xlab="Training points", ylab="Decision tree nodes")
lines(n, p_nodes_bp, col="blue", type="o")
legend(  x="topleft",
       , legend=c("Diagonal", "Parallel")
       , col=c("red", "blue")
       , lty=c(1,1)
       )
dev.off()

# After prunning training error and test error 
png("errorap.png")
limy <- c(min(d_training_error_ap,d_test_error_ap),max(d_training_error_ap,d_test_error_ap))
plot(n, d_training_error_ap, col="red", ylim=limy, type="o", xlab="Training points", ylab="Percentual error")
lines(n, d_test_error_ap, col="red", type="o", lty=3)
lines(n, p_training_error_ap, col="blue", type="o")
lines(n, p_test_error_ap, col="blue", type="o", lty=3)
legend(  x="topright",
       , legend=c("Diagonal train", "Diagonal test", "Parallel train", "Parallel test")
       , col=c("red", "red", "blue", "blue")
       , lty=c(1,3,1,3)
       )
dev.off()

# After prunning node count
png("nodecap.png")
limy <- c(min(p_nodes_ap, d_nodes_ap),max(p_nodes_ap,d_nodes_ap))
plot(n, d_nodes_ap, col="red", ylim=limy,type="o", xlab="Training points", ylab="Decision tree nodes")
lines(n, p_nodes_ap, col="blue", type="o")
legend(  x="topleft",
       , legend=c("Diagonal", "Parallel")
       , col=c("red", "blue")
       , lty=c(1,1)
       )
dev.off()
