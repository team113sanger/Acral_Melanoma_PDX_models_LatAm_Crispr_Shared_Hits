### Set up ###

library(tidyverse)

here::i_am("src/02_remove_pan_cancer_essential_genes.R")

### Loading data ###

# BAGEL output
bagel_output <- read_csv("data/final_gene_level_results.csv")

# Pan-cancer esential genes
pan_genes <- read_csv("metadata/pan_genes.csv")
pan_genes <- pan_genes$Gene

### Processing data ###

# Filtering BAGEL output to remove pan-cancer essential genes
filtered_bagel_output <- bagel_output |>
  filter(!(gene %in% pan_genes)) |>
  rename(sLFC = mean_slfc)

### Saving processed file ###
write_csv(filtered_bagel_output, "processed_data/filtered_bagel_output.csv")
