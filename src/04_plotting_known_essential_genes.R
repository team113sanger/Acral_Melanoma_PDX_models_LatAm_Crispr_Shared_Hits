### Set up ###

library(tidyverse)
library(ggrepel)

here:i_am("src/04_plotting_known_essentials.R")

### Loading data ###

# BAGEL output for the acral melanoma crispr screening
bagel_output <- read_csv("data/final_gene_level_results.csv") |>
  rename(sLFC = mean_slfc)

### Processing data ###

# Known essential genes envolved with cell cycle and DNA damage response to highlight
genes_to_highlight <- c("PLK1", "AURKB", "ATR", "CHK1", "WEE1", "PCNA", "CDK1", "RAD51C", "RPA1", "RPA2")

# Fixing CHK1 mispelling
bagel_output <- bagel_output |> 
  mutate(gene = ifelse(gene == "CHEK1", "CHK1", gene))

# Flagging genes for plotting
flagged_bagel_output <- bagel_output |> 
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
        gene %in% genes_to_highlight ~ gene,
        !gene %in% genes_to_highlight ~ NA
      )
  ) |>
  filter(timepoint == "D21")


### Plotting and saving ###

p <- ggplot(flagged_bagel_output, aes(x = line, y = sLFC)) +
  geom_point(aes(color = sLFC), 
             position = position_jitter(0.2, seed = 1), stroke = NA) + 
  scale_color_gradient2(midpoint = 0, low = "#DC0000B2", mid = "white", high = "#3C5488B2") +
  geom_text_repel(aes(label = gene_name),
                  position = position_jitter(0.2, seed = 1), 
                  min.segment.length = 0,
                  size = 3,
                  max.overlaps = Inf) +
  labs(y = "sLFC", title = "Known Essential Genes") +
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
  file.path("plots", "manhattan_all_cell_lines_highlighted_known_essentials.pdf"),
  plot = p,
  width = 4,
  height = 4
)
