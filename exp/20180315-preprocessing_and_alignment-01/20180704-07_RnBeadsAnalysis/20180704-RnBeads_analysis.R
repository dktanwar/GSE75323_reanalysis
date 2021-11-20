suppressPackageStartupMessages(library("RnBeads"))
library(RnBeads.mm10)
library(doParallel)
library(stringr)

# parallel.setup(detectCores() - 26)
parallel.setup(4)

# Disable greedycut (filtering)
rnb.options("filtering.greedycut"=FALSE)
# Disable intersample variation plots (exploratory analysis)
rnb.options("exploratory.intersample"=FALSE)
# Reduce the subsampling number for estimating density plots
rnb.options("distribution.subsample"=100000)
# Disable regional methylation profiling (exploratory analysis)
rnb.options("exploratory.region.profiles"=NULL)
# Disable chromosome coverage plots (QC, sequencing data only)
rnb.options("qc.coverage.plots"=FALSE)

# ulimit::memory_limit(120000)
rnb.options(replicate.id.column = NULL)

samples <- list.files(path = "./input", full.names = F, pattern = ".cov.gz")

table <- read.table("input/20180702-annotation_samples.txt.gz", sep = "\t", header = T, 
                    stringsAsFactors = F)[,c(1,6,7)]

table <- table[!duplicated(table),]
table$source_name <- as.character(sapply(table$source_name, function(x) strsplit(x, "_")[[1]][4]))

colnames(table) <- c("barcode", "Age", "Group")
table$filename_bed <- samples

table$Group1 <- table$Group2 <- table$Group3 <- table$Group
table$Group1[table$Group1 == "low protein"] <- NA
table$Group2[table$Group2 == "high fat"] <- NA
table$Group3[table$Group3 == "control"] <- NA

table$Age1 <- table$Age2 <- table$Age3 <- table$Age4 <- table$Age5 <- table$Age6 <- table$Age7 <- table$Age8 <- table$Age9 <- table$Age10 <- table$Age

#table$Age1 <- table$Age2 <- table$Age3 <- table$Age4 <- table$Age


table$Age1[table$Age1 == "10 weeks"] <- NA
table$Age2[table$Age2 == "12 weeks"] <- NA
table$Age3[table$Age3 == "13 weeks"] <- NA
table$Age4[table$Age4 == "13.5 weeks"] <- NA
table$Age5[table$Age5 == "10 weeks" | table$Age5 == "12 weeks"] <- NA
table$Age6[table$Age6 == "10 weeks" | table$Age6 == "13 weeks"] <- NA
table$Age7[table$Age7 == "10 weeks" | table$Age7 == "13.5 weeks"] <- NA
table$Age8[table$Age8 == "12 weeks" | table$Age8 == "13 weeks"] <- NA
table$Age9[table$Age9 == "12 weeks" | table$Age9 == "13.5 weeks"] <- NA
table$Age10[table$Age10 == "13 weeks" | table$Age10 == "13.5 weeks"] <- NA

table$sampleID <- paste(table$Group, table$Age, table$barcode, sep = "-")
table$sampleID <- str_replace_all(string = table$sampleID, pattern = " ", 
                                  replacement = "")

write.table(table, file = "./output/annotationRnBeads.csv", quote = F, row.names = F, sep = ",")

rnb.options(assembly="mm10", import.bed.style="bismarkCov")
data.source <- c("./input", "./output/annotationRnBeads.csv")

#rnb.execute.import(data.source = data.source, data.type = "bs.bed.dir", dry.run = T)

#result <- rnb.run.import(data.source=data.source, data.type="bs.bed.dir", dir.reports=".")

rnb.run.analysis(data.source = data.source, dir.reports = "./output/RnBeads_Analysis/",
                 data.type="bs.bed.dir", initialize.reports = T, build.index = T, 
                 save.rdata = T)

sessionInfo()
