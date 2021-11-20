library(readxl)

final.data <- read_xlsx("../Shea_2015_sigling_correlations.xlsx", trim_ws = T)[1,-c(1:3)]

final.data <- data.frame(Samples = as.character(colnames(final.data)), Groups = as.character(final.data[1,]), 
                         stringsAsFactors = F)
final.data$Samples <- as.character(sapply(final.data$Samples, function(x) strsplit(x, "..", fixed = T)[[1]][1]))

rrbs <- data.table::fread("../epigenomeDetails.mm9.2.RRBS.Promoter_centered_main_filtered.txt", sep = "\t", header = T, stringsAsFactors = F, nThread = 16, showProgress = T, data.table = F)
