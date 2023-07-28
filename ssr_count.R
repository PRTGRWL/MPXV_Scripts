#!/bin/Rscript

# © Nityendra Shukla
# Please cite our work if you use this script: Preeti Agarwal, Nityendra Shukla, \
# XXX, Sahil Mahfooz*, Jitendra Narayan* Comparative Genome Analysis Reveals Insights \
# into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the \
# Active Role of Trinucleotide Motif ATC 2023.
# Contact: nitinshukla218@gmail.com
# Usage: Run this script using an IDE of your choice, and modify it as \
# needed.


library(readxl)
library(tidyverse)

#setwd("~/ssr_count/")

ssr_count <- read_excel("ssr_countvsgenome.xlsx")
colnames(ssr_count) <- c("genome", "SSR")

plt <- ggplot(ssr_count, aes(x = genome, y = SSR)) + geom_jitter(size = 1, color = "darkgreen") +
  theme_classic() +
  scale_y_continuous(limits = c(270,345)) +
#  scale_x_discrete(breaks = seq(0, 500, by = 50)) +
  labs(
    title = "Average SSR counts across all Mpox genomes",
    x = "Genome", y = "SSR Count"
  ) +
  theme(
    plot.title = element_text(hjust = 0),
    axis.text.y = element_text(face = "bold", size = 10),
    axis.text.x = element_text(face = "bold", size = 10),
    axis.title.x = element_text(face = "bold", size = 11),
    axis.title.y = element_text(face = "bold", size = 11)
  )

# ggsave("ssr_count.png", dpi = 300,
#        plot = plt, height = 5, width = 5,
#        units = "in")
# 
