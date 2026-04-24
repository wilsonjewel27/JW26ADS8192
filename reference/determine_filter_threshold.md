# The filtering diagnostics evaluate how the pre-filtering threshold (minimum count per group) affects the number of discoveries, enabling users to choose an informed threshold

The filtering diagnostics evaluate how the pre-filtering threshold
(minimum count per group) affects the number of discoveries, enabling
users to choose an informed threshold

## Usage

``` r
determine_filter_threshold(
  se_ln,
  count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500),
  assay_name = "counts",
  ref_level = "Tconv",
  group_var = "cell_type",
  p_threshold = 0.05
)
```

## Arguments

- se_ln:

  A SummarizedExperiment object

- count_thresholds:

  minimum threshold of gene counts (default: 'c(0, 1, 5, 10, 20, 50,
  100, 200, 500)')

- assay_name:

  Name of assay to use (default: "counts")

- ref_level:

  Sets the reference for comparison (default: "Tconv")

- group_var:

  metadata for grouping (default: "cell_type")

- p_threshold:

  Significance threshold for adjusted p-value(default: 0.05)

## Value

A dataframe summarizing the number of significant genes per threshold

## Examples

``` r
data(example_se)

# Step 1: Evaluate how model preforms using different threshold values
example_se_filtering_assessment<- determine_filter_threshold(
se_ln = example_se,
count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500),
assay_name = "counts",
ref_level = "Tconv",
group_var = "cell_type",
p_threshold = 0.05)
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

# Step 2: Pick the best min count threshold and set \min_count_per_group` (default: 10)`
```
