#!/bin/sh
while read line; do parallel-fastq-dump --sra-id $line --threads 10 --skip-technical -F --outdir out/ --split-files -O fastq; done < GSE117159_SRR_Acc_List2.txt