#Test for filtering low gene expression
test_that("The returned ob ject is an se, and has more than 2 columns", {
  data(example_se)

  results <- filter_low_exp_genes(
    se_ln = example_se,
    min_count_per_group = 10,
    assay_name = "counts"
  )

  expect_gte(ncol(colData(results)), 2)
  expect_s4_class(results, "SummarizedExperiment")
})

