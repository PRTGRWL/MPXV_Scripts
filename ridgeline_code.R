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
library(ggridges)

# setwd("~/ridgeline_plot/")
# Read file
den <- read.csv("data_ridgeline.csv", sep = "\t") %>%
  group_by(genome) %>%
  mutate(ssr_density = stop - start + 1)

# Retrieve relative SSR density

ssr_sum <- aggregate(ssr_density ~ genome, data = den, FUN = sum)
contig <- aggregate(contig ~ genome, data = den, FUN = mean)
lineage <- den[, c(5, 8)]
lineage <- lineage[!duplicated(lineage), ]

merge <- merge(merge(ssr_sum, contig, by = "genome"), lineage, by = "genome")
merge$lineage <- as.factor(merge$lineage)

plt <- merge %>%
  group_by(lineage) %>%
  mutate(rel_density = (ssr_density / contig) * 100000)

# Plot 
p1 <- ggplot(plt, aes(x = rel_density, y = lineage, fill = lineage)) + 
  geom_density_ridges(quantile_lines = TRUE, quantiles = 2) +
  theme_ridges() +
  theme(
    legend.position = "none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 5)
  ) +
  xlab("Relative density across MPXV lineages") +
  ylab("Lineage")

#Save density plot
#ggsave("ridgeline_density.png", 
#       device = "png", plot = p1, dpi = 300, bg = "white", 
#       width = 7, height = 9, units = "in")

############################## Relative SSR abundance ###################
#Read file
abund <- read.csv("data_ridgeline.csv", sep = "\t", 
               row.names = NULL)

# Retrieve SSR abundance
ssr_abund <- aggregate(lineage ~ genome, data = abund, FUN = length)
colnames(ssr_abund) <- c("genome", "ssr_abund")
contig <- aggregate(contig ~ genome, data = abund, FUN = mean)
lineage <- abund[, c(5, 8)]
lineage <- lineage[!duplicated(lineage), ]

merge <- merge(merge(ssr_abund, contig, by = "genome"), lineage, by = "genome")
plt <- merge %>%
  group_by(lineage) %>%
  mutate(rel_abund = (ssr_abund / contig) *  1000000)
plt$lineage <- as.factor(plt$lineage)

# Plot
p2 <- ggplot(plt, aes(x = rel_abund, y = lineage, fill = lineage)) + 
  geom_density_ridges(quantile_lines = TRUE, quantiles = 2) +
  theme_ridges() +
  theme(
    legend.position = "none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 5)
  ) +
  xlab("Relative abundance across MPXV lineages") +
  ylab("Lineage")

#Save
#ggsave("ridgeline_frequency.png", 
#       device = "png", plot = p2, dpi = 300, bg = "white", 
#       width = 7, height = 9, units = "in")
