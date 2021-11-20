suppressPackageStartupMessages(library("methylKit"))

anno <- read.csv("input/annotationRnBeads.csv", header = T, stringsAsFactors = F)
anno <- anno[anno$Group != "low protein",]
files.list <- as.list(paste0("./input/",anno$Sample_ID))

myobj <- methRead(location = files.list, sample.id = as.list(anno$Group), 
                  assembly = "mm10", pipeline = "bismarkCoverage", 
                  header = F, skip = 1, dbtype = "tabix",
                  treatment = as.numeric(factor(anno$Group)) - 1)

getMethylationStats(myobj[[2]],plot=TRUE,both.strands=FALSE)
getMethylationStats(myobj[[1]],plot=TRUE,both.strands=FALSE)

meth <- unite(myobj, destrand=FALSE)

head(meth)

getCorrelation(meth,plot=TRUE)

myDiff <- calculateDiffMeth(meth)

myDiff25p.hyper=getMethylDiff(myDiff,difference=25,qvalue=0.01,type="hyper")
myDiff25p.hypo=getMethylDiff(myDiff,difference=25,qvalue=0.01,type="hypo")
myDiff25p=getMethylDiff(myDiff,difference=25,qvalue=0.01)

diffMethPerChr(myDiff,plot=FALSE,qvalue.cutoff=0.01, meth.cutoff=25)

library(genomation)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)

gene.obj <- readTranscriptFeatures("./input/mm10.refseq.genes.bed")

##### https://www.biostars.org/p/67291/
diffAnn=annotateWithGeneParts(as(myDiff25p,"GRanges"),gene.obj)
head(getAssociationWithTSS(diffAnn))

getTargetAnnotationStats(diffAnn,percentage=TRUE,precedence=TRUE)
plotTargetAnnotation(diffAnn,precedence=TRUE,
                     main="differential methylation annotation")
save.image(file = "20180717.RData")
sessionInfo()
