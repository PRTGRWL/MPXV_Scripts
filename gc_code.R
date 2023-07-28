#!/bin/Rscript

# © Nityendra Shukla
# Please cite our work if you use this script: Preeti Agarwal, Nityendra Shukla, \
# XXX, Sahil Mahfooz*, Jitendra Narayan* Comparative Genome Analysis Reveals Insights \
# into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the \
# Active Role of Trinucleotide Motif ATC 2023.
# Contact: nitinshukla218@gmail.com
# Usage: Run this script using an IDE of your choice, and modify it as \
# needed.


library(reshape2)
library(tidyverse)
library(readxl)

# setwd("~/gc_content/")
# Read file
gc <- read_excel("gc_at_content.xlsx")
gc_melt <- melt(data = gc, id.vars = "genome", variable.name = "group")
gc_melt <- gc_melt %>%
  group_by(group)

#Plot 
plt <- ggplot(gc_melt, aes(x = genome, y = value, color = group)) +
  geom_line() + geom_point(size = 1.5, shape = 16) +
  scale_y_continuous(limits = c(0,100)) + theme_bw() +
  labs(
    title = "GC and AT content in SSRs",
    x = "Genome #", y = NULL,
    color = NULL) +
  guides(color = guide_legend(override.aes = list(size = 3.5))) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(face = "bold", size = 10),
    axis.text.y = element_text(face = "bold", size = 10),
    axis.title.x = element_text(face = "bold", size = 12, colour = "black"),
    legend.title = NULL,
    legend.text = element_text(face = "bold", size = 10))

# ggsave("gc_content.png", dpi = 300, plot = plt,
#        height = 5, width = 5, unit = "in")
