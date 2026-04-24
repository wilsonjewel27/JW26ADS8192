# Visualize results as a volcano plot

Visualize results as a volcano plot

## Usage

``` r
generate_volcano(
  res_df,
  fc_threshold = 0.5,
  xlab = "log2 Fold Change (Treg vs Tconv)",
  set_title = "Volcano Plot - Lymph Node Treg vs Tconv",
  p_threshold = 0.05
)
```

## Arguments

- res_df:

  Dataframe of log2fold-changed shrinkage applied to ds

- fc_threshold:

  fold change threshold(default: 0.5)

- xlab:

  The label of the x-axis

- set_title:

  The title of the plot

- p_threshold:

  The threshold that defines a gene's significance (default: 0.05)

## Value

volcano pot with significant genes highlighted

## Examples

``` r
data(example_se)

# Step 1; Filter low expression genes
se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#> Genes after filtering: 50 
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

# Step 3: Run log2_shrinkage on DESeq2 results to improve estimates
se_dge_shrink <- log2_shrinkage(se_dge)
#> using 'apeglm' for LFC shrinkage. If used in published research, please cite:
#>     Zhu, A., Ibrahim, J.G., Love, M.I. (2018) Heavy-tailed prior distributions for
#>     sequence count data: removing the noise and preserving large differences.
#>     Bioinformatics. https://doi.org/10.1093/bioinformatics/bty895

# Step 4: Generate a volcano plot from log2_shrinkage results
example_se_volcano<- generate_volcano(
res_df = se_dge_shrink,
fc_threshold =  0.5,
xlab = "log2 Fold Change (Treg vs Tconv)",
set_title = "Volcano Plot - Lymph Node Treg vs Tconv",
p_threshold = 0.05)
```
