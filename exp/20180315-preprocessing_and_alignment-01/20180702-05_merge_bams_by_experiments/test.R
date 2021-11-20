files <- list.files(path = "./input", pattern = ".bam", full.names = T)
anno <- read.delim("./input/SraRunTable.txt", sep = "\t", 
                   stringsAsFactors = F)[,c(3,4,10:15,28,29)]

write.table(x = anno, file = gzfile("./output/20180702-annotation_samples.txt.gz"), 
            quote = F, sep = "\t", row.names = F)

anno <- anno[,c(1,3)]

sp.anno <- split(x = anno, f = anno$Experiment)

for(i in 1:length(sp.anno)){
  if(nrow(sp.anno[[i]]) > 1){
    a <- files[grep(pattern = paste(sp.anno[[i]][,2], collapse = "|"), x = files)]
    b <- paste0("samtools merge -n -@ 32 ./output/", sp.anno[[i]][1,1], ".bam ", 
                paste(a, collapse = " "))
    system(b)
  } else{
    c <- files[grep(pattern = sp.anno[[i]][,2], x = files)]
    d <- paste0("ln -sr ", c, " ./output/", sp.anno[[i]][,1], ".bam")
    system(d)
  }
}
