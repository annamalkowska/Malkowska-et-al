#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1)

##
if(!require(dichromat)){
    install.packages("dichromat")
    library(dichromat)
}

if(!require(dplyr)){
    install.packages("dplyr")
    library(dplyr)
}

#read in files from bedtools coverage part of code
#normalise 
bed <- read.table(args[1], header=F)

#count <- as.numeric(read.csv(args[2], header=F))

count <- read.table(args[2], header=F)
count <- as.numeric(count$V1)

#normalise
bed$count <- count
bed$CPM <- (bed$V5 * bed$count)/1000000

#remove unmapped chromosomes
bed <- dplyr::filter(bed, V4 !=".")

#calculate means 
data <- bed %>%
  group_by(V4) %>%
  summarise(mean=mean(CPM))

write.table(data, "coverage.txt")
