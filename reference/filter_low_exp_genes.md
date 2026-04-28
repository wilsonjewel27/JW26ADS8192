# Filter genes with low expression

Filter genes with low expression

## Usage

``` r
filter_low_exp_genes(se_ln, min_count_per_group = 10, assay_name = "counts")
```

## Arguments

- se_ln:

  A SummarizedExperiment object

- min_count_per_group:

  The minimum threshold of gene count (default: 10)

- assay_name:

  Name of assay to use (default: "counts")

## Value

A SummarizedExperiment subset of genes with greater than n counts

## Examples

``` r
data(example_se)

# Step 1; Filter low expression genes
se_filtered <- filter_low_exp_genes(se_ln = example_se, min_count_per_group = 10, assay_name = "counts")
#> Genes after filtering: 500 
#> colData names: cell_id cell_type batch
```
