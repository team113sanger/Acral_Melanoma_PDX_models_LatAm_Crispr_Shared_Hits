### Set Up ###

library(renv)
renv::init()

library(here)
library(tidyverse)

here::i_am("src/01_filtering_common_genes.R")

### Functions ###

# Filtering significant genes called essential by BAGEL by cell line and timepoint
filtering_all_essentials <- function(df, line_timepoint) {
  
  filtered_df <- df |>
    filter(line_timepoint == !!line_timepoint) |>
    filter(called_essential == "TRUE") |>
    filter(FDR < 0.05) |>
    select(gene)
  
  gene_list <- as.character(filtered_df$gene)
  
  return(gene_list)
  
}

# Filtering significant genes called essential by BAGEL and with unknown status by cell line and timepoint
filtering_unknown_essentials <- function(df, line_timepoint) {
  
  filtered_df <- df |>
    filter(line_timepoint == !!line_timepoint) |>
    filter(called_essential == "TRUE") |>
    filter(status == "unknown") |>
    filter(FDR < 0.05) |>
    select(gene)
  
  gene_list <- as.character(filtered_df$gene)
  
  return(gene_list)
  
}

# Get shared genes and save list as .txt
get_shared_and_save <- function(list_1, list_2, file) {
  
  shared_list <- intersect(list_1, list_2)
  
  writeLines(shared_list, file)
  
  return(shared_list)
  
}

### Loading data ###

bagel_output <- read_csv("data/final_gene_level_results.csv")

### Processing data ###

# Getting all essential genes per cell line and timepoint
filtered_all_essentials <- pmap(
  list(
    df = rep(list(bagel_output), 4),
    line_timepoint = list("AM007_D14", "AM007_D21", "AM016_D14", "AM016_D21")
  ),
  .f = filtering_all_essentials
)

am007_d14_all_essentials <- filtered_all_essentials[[1]]
am007_d21_all_essentials <- filtered_all_essentials[[2]]
am016_d14_all_essentials <- filtered_all_essentials[[3]]
am016_d21_all_essentials <- filtered_all_essentials[[4]]

# Getting list of all the shared genes between timepoints per cell line
am007_all_shared_essential <- get_shared_and_save(am007_d14_all_essentials,
                                                  am007_d21_all_essentials,
                                                  "processed_data/am007_all_shared_essentials.txt")
am016_all_shared_essential <- get_shared_and_save(am016_d14_all_essentials,
                                                  am016_d21_all_essentials,
                                                  "processed_data/am016_all_shared_essentials.txt")

# Getting list of all shared genes between cell lines
am_all_shared_essentials <- get_shared_and_save(am007_all_shared_essential,
                                                am016_all_shared_essential,
                                                "processed_data/am_all_shared_essentials.txt")


# Gettings essential genes of unknown status per cell line and timepoint
filtered_unk_essentials <- pmap(
  list(
    df = rep(list(bagel_output), 4),
    line_timepoint = list("AM007_D14", "AM007_D21", "AM016_D14", "AM016_D21")
  ),
  .f = filtering_unknown_essentials
)

am007_d14_unk_essentials <- filtered_unk_essentials[[1]]
am007_d21_unk_essentials <- filtered_unk_essentials[[2]]
am016_d14_unk_essentials <- filtered_unk_essentials[[3]]
am016_d21_unk_essentials <- filtered_unk_essentials[[4]]

# Getting list of all the shared genes between timepoints per cell line
am007_unk_shared_essential <- get_shared_and_save(am007_d14_unk_essentials,
                                                  am007_d21_unk_essentials,
                                                  "processed_data/am007_unk_shared_essentials.txt")
am016_unk_shared_essential <- get_shared_and_save(am016_d14_unk_essentials,
                                                  am016_d21_unk_essentials,
                                                  "processed_data/am016_unk_shared_essentials.txt")

# Getting list of all shared genes between cell lines
am_unk_shared_essentials <- get_shared_and_save(am007_unk_shared_essential,
                                                am016_unk_shared_essential,
                                                "processed_data/am_unk_shared_essentials.txt")


