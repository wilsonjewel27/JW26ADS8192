
<!-- badges: start -->
[![R-CMD-check](https://github.com/wilsonjewel27/JW26ADS8192/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/wilsonjewel27/JW26ADS8192/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<!-- badges: start -->
[![pkgdown](https://github.com/wilsonjewel27/JW26ADS8192/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/wilsonjewel27/JW26ADS8192/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

# JW26ADS8192

Designed for RNA-seq workflows, **JW26ADS8192** provides a streamlined
pipeline to differential expression results. Use a SummarizedExperiment
object through the R package interface, or supply raw count matrices and
sample metadata (TSV/CSV) directly via the command-line interface.

------------------------------------------------------------------------

## R Studio Analysis

### Installation

``` r
# Install the package from GitHub
remotes::install_github("JW26ADS8192")
```

### Quick Start

``` r
# Load package and example data (SummarizedExperiment)
library(JW26ADS8192)
data(example_se)

# Pick the optimal 'minimun gene count' filtering threshold.
example_se_filtering_assessment <- determine_filter_threshold(
  se_ln            = example_se,
  count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500), 
  assay_name       = "counts", 
  ref_level        = "Tconv", 
  group_var        = "cell_type", 
  p_threshold      = 0.05
  )

# Filter out the low expression genes
se_filtered <- filter_low_exp_genes(
  se_ln               = example_se, 
  min_count_per_group = 10, 
  assay_name          = "counts"
  )

# Run the DESeq2 pipeline
se_dge<- run_DESeq2(se_ln = se_filtered, group_var = "cell_type", ref_level = "Tconv")

# Shrink log2 fold-change estimates
se_dge_shrink <- log2_shrinkage(dds = se_dge, shrinkage = "apeglm")

# Summarize Gene Expression
DESeq2_gene_reg_summary<- gene_regulation_summary(
  res_df       = se_dge_shrink, 
  p_threshold  = 0.05, 
  fc_threshold =  0.5
  )

# Visualize
example_se_volcano<- generate_volcano(
  res_df        = se_dge_shrink, 
  fc_threshold  =  0.5, 
  xlab          = "log2 Fold Change (Treg vs Tconv)", 
  set_title     = "Volcano Plot - Lymph Node Treg vs Tconv", 
  p_threshold   = 0.05
  )

# Export Results
example_se_exports<- export_outputs(
  res_df         = se_dge_shrink, 
  summary_df     = DESeq2_gene_reg_summary, 
  filtering_diag = example_se_filtering_assessment, 
  volcano        = example_se_volcano, 
  output_dir     = file.path("(tempdir()", "de_output") )
```

------------------------------------------------------------------------

## Command-Line Interface (via Rapp)

### Installation

``` bash
# Install the package from GitHub
Rscript -e "Rapp::install_pkg_cli_apps('JW26ADS8192')"
```

### Quick Start

``` bash
# Load package and example data (TSV)
ex_counts_path <- system.file("testdata", "example_counts.tsv", package = "JW26ADS8192")
ex_meta_path   <- system.file("testdata", "example_meta.tsv", package = "JW26ADS8192")

Sys.setenv(EX_COUNTS = ex_counts_path)
Sys.setenv(EX_META   = ex_meta_path)

# Pick the optimal 'minimun gene count' filtering threshold.
JW26ADS8192 determine_filter_threshold --count $EX_COUNTS --meta $EX_META --output ./results/

# Filter out the low expression genes
JW26ADS8192 filter_low_exp_genes --count $EX_COUNTS --meta $EX_META --output ./results/

# Run the DESeq2 pipeline
JW26ADS8192 run_DESeq2 --input ./results/se_filtered.rds --output ./results/

# Shrink log2 fold-change estimates
JW26ADS8192 log2_shrinkage  --input ./results/se_dge.rds --output ./results/

# Summarize Gene Expression
JW26ADS8192 gene_regulation_summary  --input ./results/dge_shrink.rds --output ./results/

# Visualize
JW26ADS8192 generate_volcano --input ./results/dge_shrink.rds --output ./results/
```

------------------------------------------------------------------------

## Notes

JW26ADS8192 **R-package** includes an additional function (7 total
functions) which collectively generates and exports
filtering_analysis.tsv, dge_shrink.tsv, volcano_plot.pdf, and
volcano_plot.png to current working directory. JW26ADS8192 **CLI** only
includes 6 functions, which generate and export deliverable within a
single step.
