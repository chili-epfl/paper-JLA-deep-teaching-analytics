#!/usr/bin/env Rscript

# This script takes 
# Usage: visualizePerformancesFolder.R <dir-with-rdata-files>
# NB: It requires quite a few data files from different schemas for the graphs to work correctly

library(ggplot2)
library(feather)

args <- commandArgs(trailingOnly=FALSE)
# Get the --file argument to get the current script location
arg <- (args[grepl("--file=",args,fixed=T)])[1]
fullpath <- unlist(strsplit(arg,"--file=", fixed=T))[2]
path <- dirname(normalizePath(fullpath))

args <- commandArgs(trailingOnly=TRUE)
print(args)
if(length(args)!=1){
  stop("Wrong number of arguments. Usage:\nvisualizePerformancesFolder.R <dir-with-rdata-files>")
}

strdir <- args[1]


# Find and read the RData files
# TODO: for Python stuff, store the data using feather-format!
files <- list.files(path = strdir, pattern = "\\.RData$", ignore.case = T)

df <- data.frame()
if(length(files)>0){
  
  for(file in files){
    
    out <- load(paste(strdir,file,sep=.Platform$file.sep))
    #print(out)
    data <- data.frame(label=label, auc=auc, kappa=cm$overall['Kappa'], acc=cm$overall['Accuracy'], f1=f1)
    
    if(nrow(df)==0) df <- data
    else df <- rbind(df,data)
  }
  
}else{
  stop("No data files in the specified location!")
}

# Add some group variables for each kind of target, sources, validation model
df$model <- factor(sapply(as.character(df$label), FUN=function(x){unlist(strsplit(x, split = "_", fixed = T))[1]}))
df$sources <- factor(sapply(as.character(df$label), FUN=function(x){unlist(strsplit(x, split = "_", fixed = T))[2]}))
df$modeltype <- factor(sapply(as.character(df$label), FUN=function(x){unlist(strsplit(x, split = "_", fixed = T))[3]}))
df$validation <- factor(sapply(as.character(df$label), FUN=function(x){unlist(strsplit(x, split = "_", fixed = T))[4]}))
df$target <- factor(sapply(as.character(df$label), FUN=function(x){unlist(strsplit(x, split = "_", fixed = T))[5]}))
df$modelsources <- factor(paste(df$model,df$sources,sep="_"))

print(str(df))

setwd(path)

# Graphs for Activity
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=acc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Accuracy, Activity")
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=kappa)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Kappa, Activity")
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=auc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("AUC, Activity")
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=f1)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("F1 Score, Activity")
gg

# Graphs for Social
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=acc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Accuracy, Social")
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=kappa)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Kappa, Social")
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=auc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("AUC, Social")
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=f1)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("F1 Score, Social")
gg