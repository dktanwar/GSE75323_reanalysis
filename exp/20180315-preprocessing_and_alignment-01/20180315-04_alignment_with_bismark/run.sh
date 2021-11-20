#!/usr/bin/env bash

# Data was aligned to the UCSC genome

for i in `find ./input -name *_1_paired.fastq.gz`
do
    f2=`echo $i | cut -d "_" -f1`
    base=`basename $f2`
    
    bismark --version > ./log/${base}.log 2>> ./log/${base}.log && mkdir -p ./output/${base} && bismark ./input/mm10/ -1 $i -2 ${f2}_2_paired.fastq.gz --multicore 8 -o ./output/${base} --temp_dir ./output/${base} --bowtie2 2>> ./log/${base}.log >> ./log/${base}.log && sudo /home/ubuntu/softwares/bin/clearCache
done
