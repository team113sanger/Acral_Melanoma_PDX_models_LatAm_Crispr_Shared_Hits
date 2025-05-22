### Set Up ###

library(tidyverse)
library(ggVennDiagram)

here::i_am("src/05_plotting_am_venn_diagram.R")

### Loading data ###

# BAGEL output for acral cell lines crispr screening filtered to retain only shared essentials genes of unknown status
bagel_output <- read_csv("data/final_gene_level_results.csv") |>
  filter(status == "unknown") |>
  filter(called_essential == "TRUE") |>
  filter(FDR < 0.05)

# Getting list of genes to plot
gene_list <- list(
  AM007_D14 = bagel_output$gene[bagel_output$line_timepoint == "AM007_D14"],
  AM007_D21 = bagel_output$gene[bagel_output$line_timepoint == "AM007_D21"],
  AM016_D14 = bagel_output$gene[bagel_output$line_timepoint == "AM016_D14"],
  AM016_D21 = bagel_output$gene[bagel_output$line_timepoint == "AM016_D21"]
)

### Plotting and saving ###

p_venn <- ggVennDiagram(
  gene_list,
  label_alpha = 0,
  edge_lty = "blank",
  set_size = 4,
  category.names = c("AM007 D14", "AM007 D21", "AM016 D14", "AM016 D21")) +
  scale_x_continuous(expand = expansion(mult = .1)) +
  ggplot2::scale_fill_gradient(low = "#F39B7FB2", high = "#DC0000B2") +
  labs(fill = "Genes") +
  theme(legend.title = element_text(face = "bold", hjust = 0.5, vjust = 1))
  
p_venn

ggsave(
  file.path("plots", "venn_diagram_all_cell_lines_crispr_hits.pdf"),
  plot = p_venn,
  width = 12,
  height = 6
)

### Renv snapshot ###
renv::snapshot()
