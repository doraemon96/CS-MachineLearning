# Spirals Script (assignment 1.4)
# Nicolas Soncini - 2018

#Read all files (t=test, s=spiral, p=prediction)
t10000 <- read.csv('spiral10000.test', header=FALSE)
s150 <- read.csv('spiral150.data', header=FALSE)
p150 <- read.table('spiral150.prediction', header=FALSE)
s600 <- read.csv('spiral600.data', header=FALSE)
p600 <- read.table('spiral600.prediction', header=FALSE)
s3000 <- read.csv('spiral3000.data', header=FALSE)
p3000 <- read.table('spiral3000.prediction', header=FALSE)


# Predictions n=150
p150a <- subset(p150, p150$V3 == 0)
p150b <- subset(p150, p150$V3 == 1)
minX <- min(p150$V1)
maxX <- max(p150$V1)
minY <- min(p150$V2)
maxY <- max(p150$V2)
png("p150.png")
plot(p150a$V1, p150a$V2, xlim=c(minX, maxX), ylim=c(minY, maxY), col="green", xlab="X", ylab="Y")
points(p150b$V1, p150b$V2, col="red")
dev.off()

# Predictions n=600
p600a <- subset(p600, p600$V3 == 0)
p600b <- subset(p600, p600$V3 == 1)
minX <- min(p600$V1)
maxX <- max(p600$V1)
minY <- min(p600$V2)
maxY <- max(p600$V2)
png("p600.png")
plot(p600a$V1, p600a$V2, xlim=c(minX, maxX), ylim=c(minY, maxY), col="green", xlab="X", ylab="Y")
points(p600b$V1, p600b$V2, col="red")
dev.off()

# Predictions n=3000
p3000a <- subset(p3000, p3000$V3 == 0)
p3000b <- subset(p3000, p3000$V3 == 1)
minX <- min(p3000$V1)
maxX <- max(p3000$V1)
minY <- min(p3000$V2)
maxY <- max(p3000$V2)
png("p3000.png")
plot(p3000a$V1, p3000a$V2, xlim=c(minX, maxX), ylim=c(minY, maxY), col="green", xlab="X", ylab="Y")
points(p3000b$V1, p3000b$V2, col="red")
dev.off()


