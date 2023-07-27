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
library(reshape2)
library(ggpubr)
library(ggsci)
library(RColorBrewer)

# setwd("~/barplot")
##Read file containing SSR relative abundance/density
df <- read_excel("ssr_number.xlsx")  
df[is.na(df)] <- 0

# Prepare data
df2 <- df %>%
  group_by(lineage) %>%
  summarize(Mono = mean(mono),
         Di = mean(di),
         Tri = mean(tri),
         Tetra = mean(tetra),
         Penta = mean(penta),
         Hexa = mean(hexa)) %>%
  na.omit()

# Extract contig info of all 404 genomes.
contig_data <- read.csv("contig_data.csv", sep = "\t")
lineage <- contig_data[,c(6, 8)]
lineage <- lineage[!duplicated(lineage$lineage), ]
lineage$contig <- lineage$contig / 1000000

merge <- merge(df2, lineage, by = "lineage")

plt <- merge %>%
  group_by(lineage) %>%
  mutate(Mono = Mono / contig,
         Di = Di / contig,
         Tri = Tri / contig,
         Tetra = Tetra / contig,
         Penta = Penta / contig,
         Hexa = Hexa / contig) %>%
  ungroup()
plt <- plt[, -8]

# If converting to % values:

df2$sum <- rowSums(df2[, 2:7])
lineages <- unique(df2$lineage)

final_percent <- data.frame(lineage = character(),
                            Mono = numeric(),
                            Di = numeric(),
                            Tri = numeric(),
                            Tetra = numeric(),
                            Penta = numeric(),
                            Hexa = numeric(),
                            stringsAsFactors = FALSE)

### Converting all values to percentages
for (lineage in lineages){
  #Filter dataframe
  lineage_mono <- sum(df2[df2$lineage == lineage, "Mono"])
  lineage_di <- sum(df2[df2$lineage == lineage, "Di"])
  lineage_tri <- sum(df2[df2$lineage == lineage, "Tri"])
  lineage_tetra <- sum(df2[df2$lineage == lineage, "Tetra"])
  lineage_penta <- sum(df2[df2$lineage == lineage, "Penta"])
  lineage_hexa <- sum(df2[df2$lineage == lineage, "Hexa"])

  #Get sums per lineage
  sum_mono <- sum(df2[df2$lineage == lineage, "sum"])
  sum_di <- sum(df2[df2$lineage == lineage, "sum"])
  sum_tri <- sum(df2[df2$lineage == lineage, "sum"])
  sum_tetra <- sum(df2[df2$lineage == lineage, "sum"])
  sum_penta <- sum(df2[df2$lineage == lineage, "sum"])
  sum_hexa <- sum(df2[df2$lineage == lineage, "sum"])

  #Calculate percentages
  percent_mono <- (lineage_mono / sum_mono) * 100
  percent_di <- (lineage_di / sum_di) * 100
  percent_tri <- (lineage_tri / sum_tri) * 100
  percent_tetra <- (lineage_tetra / sum_tetra) * 100
  percent_penta <- (lineage_penta / sum_penta) * 100
  percent_hexa <- (lineage_hexa / sum_hexa) * 100

  #New dataframe
  final_percent <- rbind(final_percent, data.frame(lineage = lineage,
                                                   Mono = percent_mono,
                                                   Di = percent_di,
                                                   Tri = percent_tri,
                                                   Tetra = percent_tetra,
                                                   Penta = percent_penta,
                                                   Hexa = percent_hexa,
                                                   stringsAsFactors = FALSE))
}

## Melt table
melt_df <- melt(plt, id.vars = "lineage",
                variable.name = "Type",
                value.name = "number")


#Color palettes
cp1 <- c("#6F99ADFF", "#FFC09F", "#A0CED9", 
         "#eb5959", "#999999", "#f0c348")

cp2 <- c("#FAA255", "#F0C348", "#7F7CE6", 
         "#F562AC", "#EB5959", "#9EE67A")

# Plot
p1 <- ggplot(melt_df, aes(y = lineage, x = number, fill = Type)) +
  geom_col() + 
  theme_bw() +
  scale_fill_manual(values = cp1) + 
  labs(x = "Relative density (%)",
       y = NULL) +
  theme(
    text = element_text(family = "Arial", face = "bold"),
    axis.text.y = element_text(size = 8, colour = "black"),
    axis.text.x = element_text(size = 10),
    axis.title.x = element_text(size = 11),
    legend.text = element_text(size = 8),
    legend.position = "right",
    panel.grid.major.x = element_line(colour = "lightgray")
  )

# Save plot 
# ggsave(plot = p1, "stacked_bar_R.png", 
#        width = 8, height = 7.5,
#        units = "in", dpi = 300)