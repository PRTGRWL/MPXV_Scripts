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
library(data.table)
library(ggupset)
library(ggtext)

#setwd("~/upset_plot")

data <- read_csv("upset_lineage_share.csv") 

data2 <- data %>%
  select(lineage, SSR_loci) %>%
  distinct(lineage, SSR_loci, .keep_all = TRUE) %>%
  group_by(SSR_loci) %>%
  summarize(overlap = list(lineage),
            count = n_distinct(lineage), .groups = "drop")

##ggupset
p1 <- ggplot(data2, aes(x = overlap)) + 
  geom_bar(fill = "black") +  
  geom_text(stat = "count", aes(label = ..count..), vjust = -1,
            size = 3, fontface = "bold") + 
  ylim(0, 35) +
  scale_x_upset(n_intersections = 17) +
  theme_classic() +
  labs(x = NULL, y = "# of shared SSRs",
       title = "Shared SSRs across Mpox lineages") +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", margin = margin(b=20)),
    panel.background = element_blank()
  ) +
  theme_combmatrix(combmatrix.label.text = element_text(face = "bold"))

#Save file
# ggsave(filename = "upset.png",
#        plot = p1,
#        height = 5.5, width = 7,
#        units = "in", dpi = 300)

