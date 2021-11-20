#!/usr/bin/env bash

cat SraRunTable_single_end.txt| cut -f 10| grep -v Run| parallel --jobs 20 fastq-dump --split-files 2>download_data_raw.log >> download_data_raw.log
