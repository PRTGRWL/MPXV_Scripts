#!/bin/Rscript

# © Nityendra Shukla
# Please cite our work if you use this script: Preeti Agarwal, Nityendra Shukla, \
# XXX, Sahil Mahfooz*, Jitendra Narayan* Comparative Genome Analysis Reveals Insights \
# into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the \
# Active Role of Trinucleotide Motif ATC 2023.
# Contact: nitinshukla218@gmail.com
# Usage: Run this script using an IDE of your choice, and modify it as \
# needed.


library(tidyverse)
library(pheatmap)
library(readxl)
library(reshape2)

#setwd("~/heatmap")
# Read files 
lineage <- read_excel("data_heatmap.xlsx")
ssrs <- read_excel("ssr_number.xlsx")

#Melt into long format
ssr_melt <- melt(ssrs, id.vars = "genome")
colnames(ssr_melt) <- c("genome", "gene", "ssr") #Rename columns

#Extract genome # and lineage
lineage_genome <- lineage[, c(5, 8)] 
lineage_genome <- lineage_genome[!duplicated(lineage_genome), ] 
#Merge genome #, lineage and values
merge <- merge(ssr_melt, lineage_genome, by = "genome")
merge[is.na(merge)] <- 0 #Convert NAs by 0

#Add reference genome
merge <- merge %>%
  mutate(lineage = ifelse(genome == "555", "Reference", lineage))

#Get mean of each gene grouped by lineage
result <- merge %>%
  group_by(lineage, gene) %>%
  summarize(ssr_mean = mean(ssr)) %>%
  ungroup()

#Convert again to wide format
num_data <- pivot_wider(result, names_from = gene, 
                      values_from = ssr_mean)

## Remove columns sharing same values across lineages
# Create function to remove columns with same values
unique_value <- function(x){
  length(unique(x)) == 1
}

# Get names of columns
col_remove <- sapply(num_data, unique_value)

# Remove column and update
plt <- num_data[, !col_remove]
plt <- as.data.frame(plt)
rownames(plt) <- plt$lineage
plt <- plt[, -1]

# Thanks to user @skafdasschaf: https://github.com/raivokolde/pheatmap/issues/48#issue-402653138
#use this function to make row or column names bold. 
# parameters:
#   mat: the matrix passed to pheatmap
#   rc_fun: either rownames or colnames
#   rc_names: vector of names that should appear in boldface
make_bold_names <- function(mat, rc_fun, rc_names) {
  bold_names <- rc_fun(mat)
  ids <- rc_names %>% match(rc_fun(mat))
  ids %>%
    walk(
      function(i)
        bold_names[i] <<-
        bquote(bold(.(rc_fun(mat)[i]))) %>%
        as.expression()
    )
  bold_names
}

#Assign names
rn <- rownames(plt)
cn <- colnames(plt)
#Create plot
p <- pheatmap(plt, cluster_cols = FALSE,
              col_order = order, angle_col = 0, width = 15,
              cluster_rows = FALSE, 
              fontsize_row = 14, fontsize_col = 11,
              labels_row = make_bold_names(plt, rownames, rn),
              labels_col = make_bold_names(plt, colnames, cn),
              color = colorRampPalette(c("white", "orange", "red"))
              (50), border_color = "white")

#Save plots
# ggsave(plot = p, "heatmap_number.png", device = "png", dpi = 300,
#        width = 20, height = 8, units = "in")
