# Package index

## Example Data

Load an example simulated SummarizedExperiment object

- [`example_se`](https://github.com/wilsonjewel27/JW26ADS8192/reference/example_se.md)
  : Example SummarizedExperiment for testing

## Determining the Minimal Gene Threshold

Use to determine which gene should not be included in analysis.

- [`determine_filter_threshold()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/determine_filter_threshold.md)
  : The filtering diagnostics evaluate how the pre-filtering threshold
  (minimum count per group) affects the number of discoveries, enabling
  users to choose an informed threshold

## Filter Low Expression Genes

Pick a threshold to filter genes with low expression counts

- [`filter_low_exp_genes()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/filter_low_exp_genes.md)
  : Filter genes with low expression

## Run DESeq2 Analysis

Run differential gene expression analysis

- [`run_DESeq2()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/run_DESeq2.md)
  : Preform Differential Gene Analysis

## Shrink Results

To get more reilable estimates run the log2_shrinkage function on DESeq2
results

- [`log2_shrinkage()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/log2_shrinkage.md)
  : Apply log2fold-change shrinkage for more reliable effect-size
  estimates

## Interpret Gene Regulation

Tabularly visualize the number for up and down regulated and
insignificant genes

- [`gene_regulation_summary()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/gene_regulation_summary.md)
  : Summarize the number of significantly non-significant(ns)/up/down
  genes at given thresholds

## Visualize Expression

Visualize the gene expression in a volcano plot

- [`generate_volcano()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/generate_volcano.md)
  : Visualize results as a volcano plot

## Export Results

Export the results of generate_volcano, determine_filter_threshold,
log2_shrinkage, and gene_regulation_summary into your working directory.

- [`export_outputs()`](https://github.com/wilsonjewel27/JW26ADS8192/reference/export_outputs.md)
  : Export differential expression results, summary counts, and
  filtering diagnostics to TSV files
