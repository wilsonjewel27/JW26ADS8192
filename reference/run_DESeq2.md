# Preform Differential Gene Analysis

Preform Differential Gene Analysis

## Usage

``` r
run_DESeq2(se_ln, group_var = "cell_type", ref_level = "Tconv")
```

## Arguments

- se_ln:

  A SummarizedExperiment object

- group_var:

  determines the column to categorization

- ref_level:

  sets the reference to a specific cell type (default: "Tconv")

## Value

The results of the Differential Gene Analysis between cell_type

## Examples

``` r
data(example_se)

# Step 1; Filter low expression genes
se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#> Genes after filtering: 50 
#> colData names: cell_id cell_type batch

# Step 2: Run the DESeq2 pipeline
se_dge<- run_DESeq2(se_ln = se_filtered, group_var = "cell_type", ref_level = "Tconv")
#> converting counts to integer mode
#> estimating size factors
#> estimating dispersions
#> gene-wise dispersion estimates
#> mean-dispersion relationship
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> final dispersion estimates
#> fitting model and testing
```
