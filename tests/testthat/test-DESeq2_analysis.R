#test-DESEQ2_analysis

test_that("invalid group_var error message works", {
  data(example_se)
#rerun previous functions
  # Step 1: Evaluate how model preforms using different threshold values and choose a threshold
  example_se_filtering_assessment<- determine_filter_threshold(example_se)
  # Step 2; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)

  expect_error(
    run_DESeq2(se_ln = se_filtered, group_var = "not_real"),
    "invalid group_var"
  )
})


test_that("invalid ref_level error message works", {
  data(example_se)

#rerun previous functions
# Step 1: Evaluate how model preforms using different threshold values and choose a threshold
  example_se_filtering_assessment<- determine_filter_threshold(example_se)
# Step 2; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)


  expect_error(
    run_DESeq2(se_ln = se_filtered, ref_level = "not_real"),
    "invalid ref_level"
  )
})

test_that("Output results are a DESeqDataSet object", {
  data(example_se)

#rerun previous functions
  # Step 1: Evaluate how model preforms using different threshold values and choose a threshold
  example_se_filtering_assessment<- determine_filter_threshold(example_se)
  # Step 2; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)


  se_dge<- run_DESeq2(se_ln = se_filtered, group_var = "cell_type", ref_level = "Tconv")

  expect_s4_class(se_dge, "DESeqDataSet")
})
