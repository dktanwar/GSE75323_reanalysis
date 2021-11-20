#!/usr/bin/env bash

cat SRR3019190.fastq | bioawk -c fastx '{print "@"$name" "$comment > "1.fastq"; print substr($seq,1,75) > "1.fastq"; print "+" > "1.fastq"; print substr($qual,1,75) > "1.fastq"; print "@"$name > "2.fastq"; print substr($seq,76,75) > "2.fastq"; print "+" > "2.fastq"; print substr($qual,76,75) > "2.fastq"}'
