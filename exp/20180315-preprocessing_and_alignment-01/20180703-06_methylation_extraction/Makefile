############################
## Author: Deepak Tanwar  ##
## Date: 20180326	  ##
############################

# This makefile will run the FastQC software to check the quality of FastQ files

SHELL:=/bin/bash
source_dir=./input
target_dir=./output

files := $(wildcard $(source_dir)/*.bam)
targets := $(patsubst $(source_dir)/%.bam, $(target_dir)/%, $(files))

all: $(targets)

$(target_dir)/%: $(source_dir)/%.bam
	mkdir -p $@ && bismark_methylation_extractor --version > ./log/$(notdir $@).log && bismark_methylation_extractor $< -p -o $@ --multicore 32 --bedGraph --cytosine_report --genome_folder /mnt/IM/DKT/genomes/gencode/mm10_release_m16/ 2>> ./log/$(notdir $@).log >> ./log/$(notdir $@).log && pigz -3 -p 32 $@/*.txt
