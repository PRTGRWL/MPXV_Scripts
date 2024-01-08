#!/bin/Rscript

# @ Preeti Agarwal
# Cite : Preeti Agarwal, Nityendra Shukla, Ajay Bhatia, Sahil Mahfooz*, Jitendra Narayan* **Comparative Genome Analysis Reveals Insights into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the Active Role of Trinucleotide Motif ATC** 2023
# Contact : prtgrwl8@gmail.com
# Usage: Run this script using an IDE of your choice, and modify it as \
# needed.


### Load library
library(readxl)
library(tidyverse)
library(ggpubr)

### change columns name
colnames(df)<- c("genome_size","No_of_SSR")

### plot
sp <- ggscatter(df, x = "genome_size", y = "No_of_SSR",
                add = "reg.line",  # Add regressin line
                add.params = list(color = "blue", fill = "lightgray"), # Customize reg. line
                conf.int = TRUE, cor.coef = T,
                cor.method = "pearson")
ggsave(plot = sp,filename = "correlation.png",dpi = 300)

