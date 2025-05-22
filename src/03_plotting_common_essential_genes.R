### Set Up ###

library(tidyverse)
library(ggrepel)

here::i_am("src/03_plotting_chosen_common_essential_genes.R")

### Loading data ###

# BAGEL results with pan cancer essential genes filtered out
filtered_bagel_output <- read_csv("processed_data/filtered_bagel_output.csv")

### Processing data for plotting ###

# List of genes to be highlighted 
highlight_genes <- c("CRKL", "MAPK1", "MDM2", "MITF", "SOX10", "CCNB1", "CCND1", "CDK2", "KRAS", "NRAS")

# Flagging significant depleted genes
filtered_bagel_output <- filtered_bagel_output |> 
  mutate(
    Significant =
      case_when(
        sLFC >= 0.5 & FDR <= 0.05 ~ "1",
        sLFC <= -0.5 & FDR <= 0.05 ~ "1", TRUE ~ "0"
      )
  ) |>
  mutate(
    gene_name = 
      case_when(
        gene %in% highlight_genes ~ gene,
        !gene %in% highlight_genes ~ NA
      )
  ) |>
  filter(timepoint == "D21")

filtered_bagel_output_ras <- filtered_bagel_output |>
  mutate(gene_name = ifelse(line == "AM007" & gene_name == "KRAS", NA, gene_name)) |>
  mutate(gene_name = ifelse(line == "AM016" & gene_name == "NRAS", NA, gene_name))

### Plotting and saving ###

p <- ggplot(filtered_bagel_output_ras, aes(x = line, y = sLFC)) +
  geom_point(aes(color = sLFC), 
             position = position_jitter(0.2, seed = 1), stroke = NA) + 
  scale_color_gradient2(midpoint = 0, low = "#DC0000B2", mid = "white", high = "#3C5488B2") +
  geom_text_repel(aes(label = gene_name),
                  position = position_jitter(0.2, seed = 1), 
                  min.segment.length = 0,
                  size = 3,
                  max.overlaps = Inf) +
  labs(y = "sLFC", title = "Common Essential Genes") +
  geom_hline(yintercept = c(-0.5, 0.5), col = "black", linetype = "dashed", linewidth = 0.5) +
  theme_classic() + theme(
    plot.title = element_text(size = 18, face = "bold", color = "black", hjust = 0.5, vjust = 1),
    axis.title.x = element_blank(),
    axis.text.x = element_text(size = 12, angle = 0, face = "bold", color = "black", vjust = 0.5),
    axis.title.y = element_text(size = 15, face = "bold"),
    axis.text.y = element_text(size = 13, face = "bold", color = "black"),
    legend.text = element_text(size = 11, face = "bold"),
    title = element_text(size = 11, face = "bold", hjust = 0.5),
    axis.line = element_line(color = "black"),
    axis.ticks = element_line(color = "black"))

ggsave(
  file.path("plots", "manhattan_all_cell_lines_highlighted_common_essential_genes_w_ras.pdf"),
  plot = p,
  width = 4,
  height = 4
)
