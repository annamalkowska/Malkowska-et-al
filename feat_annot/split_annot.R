#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1)

##
if(!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
} else {
  library(dplyr)
}

#read in files 
bed <- read.delim(args[1], header=F, skip=1)
bed <- dplyr::select(bed, V1, V2, V3, V4)
colnames(bed) <- c("chrom", "start", "end", "state")

bed$state <- as.factor(bed$state)
bed$state <- dplyr::recode(bed$state, "1" = "HP1", "2" = "H1", "3" = 
 "Gene_body_1", "4" = "Gene_body_2", "5" = "Open_promoters", 
 "6" = "Low_signal", "7" = "Enhancers", "8" = "Pc")

for (i in unique(bed$state)) {
  assign(paste0("state", i), dplyr::filter(bed, state == i))
}

list <- mget(ls(pattern = "state")) 
rm(list=ls(pattern="state"))

lapply(names(list),
       function(x, list) write.table(list[[x]], paste(x, ".bed", sep = ""),
                                    col.names=FALSE, row.names=FALSE, sep="\t", 
                                    quote=FALSE),list)
