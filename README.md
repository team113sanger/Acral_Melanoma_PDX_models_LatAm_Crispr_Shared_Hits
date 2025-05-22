# Analysis of shared vulnerabilities in Acral Melanoma cell lines AM007 and AM016

## Overview
Analysis to identify shared vulnerabilities between Acral Melanoma cell lines AM007 and AM016 from CRISPR data.

## Raw data
- `final_gene_levels_results.csv`: output of BAGEL2 analysis for AM007 and AM016.
- `pan_genes.csv`: list of pan essential genes identified using ProdeTool [**here**](https://github.com/cantorethomas/prodeTool)

## Analysis steps
1. Intersect CRISPR results from cell lines to identify all shared vulnerabilities, followed by filtering to identify genes with "unknown" status classification by BAGEL2. [`src/01_filtering_common_genes.R`](src/01_filtering_common_genes.R)
2. Filtering out a list of known pan-cancer essential genes. [`src/02_remove_pan_cancer_essential_genes.R`](src/02_remove_pan_cancer_essential_genes.R)
3. Visualisation of shared vulnerabilities of "unknown" status through a Manhattan plot. [`src/03_plotting_common_essential_genes.R`](src/03_plotting_common_essential_genes.R)
4. Visualisation of depleted known essential genes related to cell cycle and DNA damage response. [`src/04_plotting_known_essential_genes.R`](src/04_plotting_known_essential_genes.R)
5. Visualisation of all shared depleted genes between all cell lines and timepoints through a Venn diagram. [`src/05_plotting_am_venn_diagram.R`](src/05_plotting_am_venn_diagram.R)

## Project structure
```bash
tree -L 2
.
├── data
│   └── final_gene_level_results.csv
├── metadata
│   └── pan_genes.csv
├── plots
│   ├── manhattan_all_cell_lines_highlighted_common_essential_genes_w_ras.pdf
│   ├── manhattan_all_cell_lines_highlighted_known_essentials.pdf
│   └── venn_diagram_all_cell_lines_crispr_hits.pdf
├── processed_data
│   ├── am_all_shared_essentials.txt
│   ├── am_unk_shared_essentials.txt
│   ├── am007_all_shared_essentials.txt
│   ├── am007_unk_shared_essentials.txt
│   ├── am016_all_shared_essentials.txt
│   ├── am016_unk_shared_essentials.txt
│   └── filtered_bagel_output.csv
├── README.md
├── renv
│   ├── activate.R
│   ├── library
│   └── settings.json
├── renv.lock
└── src
    ├── 01_filtering_common_genes.R
    ├── 02_remove_pan_cancer_essential_genes.R
    ├── 03_plotting_common_essential_genes.R
    ├── 04_plotting_known_essential_genes.R
    └── 05_plotting_am_venn_diagram.R

8 directories, 21 files

```

# Requirements and Dependencies
## Software dependencies
- All R scripts were run using `R v4.5.0` and the packaged dependencies for each analysis are detailed within the `renv.lock` file.
- The following software was used:
  - `here` version`v1.0.1` [**here**](https://github.com/r-lib/here)
  - `renv` version `1.1.4` [**here**](https://github.com/rstudio/renv)
  - `tidyverse` version `2.0.0` [**here**](https://github.com/tidyverse/tidyverse)
  - `ggrepel` version `0.9.6` [**here**](https://github.com/slowkow/ggrepel)
  - `ggVennDiagram` version `1.5.2` [**here**](https://github.com/gaospecial/ggVennDiagram)

# Contact
  If you have any questions or comments about this repository, please contact:
  - Rafaela Fagundes : (<rf17@sanger.ac.uk>)