############################
## Author: Deepak Tanwar  ##
## Date: 20180326	  ##
############################

# This makefile will run the FastQC software to check the quality of FastQ files

SHELL:=/bin/bash
source_dir=./input
target_dir=./output

files := $(wildcard $(source_dir)/*.fastq.xz)
targets := $(patsubst $(source_dir)/%.fastq.xz, $(target_dir)/%.zip, $(files))

all: $(targets)

$(target_dir)/%.zip: $(source_dir)/%.fastq.xz
	fastqc -v > ./log/$(basename $(notdir $@)).log && fastqc <(unxz -c -T 8 $<) -o ./output/ --noextract -f fastq -t 8 -d /mnt/tmp/ 2>>./log/$(basename $(notdir $@)).log && mv ./output/63_fastqc.html $(basename $@).html && mv ./output/63_fastqc.zip $@ && xz -T 8 ./log/$(basename $(notdir $@)).log
