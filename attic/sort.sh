#!/bin/bash

for i in `find . -name "*_paired_bismark_bt2_pe.bam"`
do
    name=`echo $i | cut -d "/" -f 2`
    
    if [ ! -f ./${name}/${name}.sorted.bam ]; then
	samtools sort -m 5G -o./${name}/${name}.sorted.bam -O BAM -@ 20 $i
	echo $name
    fi
    
done
