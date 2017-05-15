#!/usr/bin/env Rscript

# This script takes 
# Usage: visualizePerformancesFolder.R <dir-with-rdata-files>
# NB: It requires quite a few data files from different schemas for the graphs to work correctly

library(ggplot2)

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
#strdir <- "../models/"

# Find and read the RData files
# TODO: for Python stuff, store the data using feather-format!
files <- list.files(path = strdir, pattern = "\\.RData$", ignore.case = T)

nor=F

df <- data.frame()
if(length(files)>0){
  
  for(file in files){
    
    out <- load(paste(strdir,file,sep=.Platform$file.sep))
    #print(out)
    data <- data.frame(label=label, auc=auc, kappa=cm$overall['Kappa'], acc=cm$overall['Accuracy'], f1=f1)
    
    if(nrow(df)==0){
      df <- data 
    }
    else{
      df <- rbind(df,data) 
    }
  }
  
}else{
  print("No R data files in the specified location!")
  nor=T
}

# Same thing for the python performance files
files <- list.files(path = strdir, pattern = "\\.perf.csv$", ignore.case = T)
if(length(files)>0){
  
  for(file in files){
    
    out <- read.csv(paste(strdir,file,sep=.Platform$file.sep))
    #print(out)
    data <- data.frame(label=out$label, auc=out$auc, kappa=out$kappa, acc=out$acc, f1=out$f1)
    
    if(nrow(df)==0){
      df <- data 
    }
    else{
      df <- rbind(df,data) 
    }
  }
  
}else{
  print("No Python data files in the specified location!")
  if(nor){
    stop("No data files to analyze!")
  }
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
  theme_bw() + ggtitle("Accuracy, Activity") + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=kappa)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Kappa, Activity")  + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=auc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("AUC, Activity") + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Activity',], aes(x=modelsources, y=f1)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("F1 Score, Activity") + geom_jitter(alpha=0.1) + coord_flip()
gg

# Graphs for Social
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=acc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Accuracy, Social") + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=kappa)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("Kappa, Social") + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=auc)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("AUC, Social") + geom_jitter(alpha=0.1) + coord_flip()
gg
gg <- ggplot(df[df$target=='Social',], aes(x=modelsources, y=f1)) + 
  geom_boxplot(aes(fill=model)) + facet_grid(validation ~ modeltype) +
  theme_bw() + ggtitle("F1 Score, Social") + geom_jitter(alpha=0.1) + coord_flip()
gg
