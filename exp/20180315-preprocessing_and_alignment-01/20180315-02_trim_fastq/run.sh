#!/usr/bin/env bash

for i in `find ./input -name *_1.fastq.xz`
do
    f2=`echo $i | cut -d "_" -f1`
    base=`basename $f2`

    time trimmomatic -Xms4g -Xmx4g PE -threads 32 -trimlog ./log/$base.log <(unxz -c -T 32 $i) <(unxz -c -T 32 ${f2}_2.fastq.xz) ./output/${base}_1_paired.fastq ./output/${base}_1_unpaired.fastq ./output/${base}_2_paired.fastq ./output/${base}_2_unpaired.fastq ILLUMINACLIP:./input/all_PE.fa:2:30:15 TRAILING:30 LEADING:30 MINLEN:30 2> ./log/${base}.STDERR && pigz -3 -p 32 ./log/$base.log && ls ./output/*.fastq | parallel --jobs 4 pigz -3 -p 8 && sudo /home/ubuntu/softwares/bin/clearCache
done
