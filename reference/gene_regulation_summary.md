# Summarize the number of significantly non-significant(ns)/up/down genes at given thresholds

Summarize the number of significantly non-significant(ns)/up/down genes
at given thresholds

## Usage

``` r
gene_regulation_summary(res_df, p_threshold = 0.05, fc_threshold = 0.5)
```

## Arguments

- res_df:

  Dataframe of log2fold-changed shrinkage applied to ds

- p_threshold:

  Significance threshold for adjusted p-value (default: 0.05)

- fc_threshold:

  fold change threshold (default = 0.5)

## Value

Summary of non-significant(ns)/up/down genes

## Examples

``` r
data(example_se)

# Step 1; Filter low expression genes
se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#> Genes after filtering: 500 
#> colData names: cell_id cell_type batch

# Step 2: Run the DESeq2 pipeline to get differential gene expression results
 se_dge<- run_DESeq2(se_filtered)
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

# Step 3: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
se_dge_shrink <- log2_shrinkage(se_dge)
#> using 'apeglm' for LFC shrinkage. If used in published research, please cite:
#>     Zhu, A., Ibrahim, J.G., Love, M.I. (2018) Heavy-tailed prior distributions for
#>     sequence count data: removing the noise and preserving large differences.
#>     Bioinformatics. https://doi.org/10.1093/bioinformatics/bty895

#Step 4: Generate the regulation summary of the genes
DESeq2_gene_reg_summary<- gene_regulation_summary(res_df = se_dge_shrink, p_threshold = 0.05, fc_threshold =  0.5)
```
