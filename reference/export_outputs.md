# Export differential expression results, summary counts, and filtering diagnostics to TSV files

Export differential expression results, summary counts, and filtering
diagnostics to TSV files

## Usage

``` r
export_outputs(
  res_df,
  summary_df,
  filtering_diag,
  volcano,
  output_dir = file.path(tempdir(), "de_output")
)
```

## Arguments

- res_df:

  Dataframe of log2fold-changed shrinkage applied to ds

- summary_df:

  A data frame summarizing the number of non-significant(ns)/up/down
  genes

- filtering_diag:

  A data frame summarizing the number of significant genes per threshold

- volcano:

  Your choice of volcano plot

- output_dir:

  Directories where files will be written

## Value

TSV files of differential expression results, summary counts, and
filtering diagnostics

## Examples

``` r
 data(example_se)

# Step 1: Evaluate how model preforms using different threshold values and choose a threshold
example_se_filtering_assessment<- determine_filter_threshold(example_se)
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.
#> converting counts to integer mode
#> -- note: fitType='parametric', but the dispersion trend was not well captured by the
#>    function: y = a/x + b, and a local regression fit was automatically substituted.
#>    specify fitType='local' or 'mean' to avoid this message next time.

# Step 2; Filter low expression genes
se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#> Genes after filtering: 500 
#> colData names: cell_id cell_type batch

# Step 3: Run the DESeq2 pipeline to get differential gene expression results
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

# Step 4: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
se_dge_shrink <- log2_shrinkage(se_dge)
#> using 'apeglm' for LFC shrinkage. If used in published research, please cite:
#>     Zhu, A., Ibrahim, J.G., Love, M.I. (2018) Heavy-tailed prior distributions for
#>     sequence count data: removing the noise and preserving large differences.
#>     Bioinformatics. https://doi.org/10.1093/bioinformatics/bty895

# Step 5: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
example_se_volcano<- generate_volcano(se_dge_shrink)

# Step 6: Generate the regulation summary of the genes
DESeq2_gene_reg_summary<- gene_regulation_summary(se_dge_shrink)

# Step 7: Export final results
example_se_exports<- export_outputs(res_df = se_dge_shrink, summary_df = DESeq2_gene_reg_summary, filtering_diag = example_se_filtering_assessment, volcano = example_se_volcano, output_dir = file.path(tempdir(), "de_output") )
#> Export complete. Files saved:
#> /tmp/RtmpcI8kYJ/de_output/de_results.tsv
#> /tmp/RtmpcI8kYJ/de_output/de_summary.tsv
#> /tmp/RtmpcI8kYJ/de_output/filtering_diagnostics.tsv
#> /tmp/RtmpcI8kYJ/de_output/volcano_plot.pdf
#> /tmp/RtmpcI8kYJ/de_output/volcano_plot.png
```
