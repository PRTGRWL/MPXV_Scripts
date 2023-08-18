#!/bin/bash 
############################################################
# Cite : Preeti Agarwal, Nityendra Shukla, Sahil Mahfooz*, Jitendra Narayan* 
# **Comparative Genome Analysis Reveals Insights into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the Active Role 
# of Trinucleotide Motif ATC** 2023
# Contact : prtgrwl8@gmail.com
# Usage: Please modify the script as per your usage. 
# needed.
############################################################

#Completeness check using CheckV
  checkv genomes.fasta OUT -t 20 -d checkv-db-v1.2

#SSR locus conservation investigation using BLASTN
  blastn -subject input.fa -query 404_file.fa -gapopen 0 -gapextend 0 -outfmt 7 -out outfile
