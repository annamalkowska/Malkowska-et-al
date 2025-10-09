#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(dplyr)
list <- sapply(list.files(pattern="annot_sorted", full.names=TRUE), read.delim, header=FALSE, simplify = FALSE,USE.NAMES = TRUE)
list <- Map(function(x,y) {names(x)[5] <- y; x},  list, names(list))
df <- as.data.frame(c(list[[1]][4], as.data.frame(lapply(list,"[",5))))
df <- as.data.frame(df)

for ( col in 1:ncol(df)){colnames(df)[col] <-  sub("..annot_sorted_state", "", colnames(df)[col])}

for (col in 1:ncol(df)){colnames(df)[col] <-  sub(".bed", "", colnames(df)[col])}
 
rownames(df) <- df$V4
df <- df[,-1] 
df <- df %>% select(-Low_signal,Low_signal)
df$annot <- colnames(df)[apply(df,1,which.max)]

df$annot_thr <- ifelse(df$annot != "Low_signal", df$annot,
                       ifelse(df$Low_signal > 0.75, "Low_signal", 
                              colnames(df[1:7])[apply(df[1:7],1,which.max)]))

#print(df)
write.csv(df, "gene_annot.csv", row.names=TRUE)

