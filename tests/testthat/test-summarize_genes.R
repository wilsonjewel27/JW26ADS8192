#test_summarize_genes


test_that("counts are numeric", {
  data(example_se)

#rerun previous functions
  # Step 1: Evaluate how model preforms using different threshold values and choose a threshold
  example_se_filtering_assessment<- determine_filter_threshold(example_se)
  # Step 2; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
  # Step 3: Run the DESeq2 pipeline to get differential gene expression results
  se_dge<- run_DESeq2(se_filtered)
  # Step 4: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
  se_dge_shrink <- log2_shrinkage(se_dge)

  results <- gene_regulation_summary(res_df = se_dge_shrink)

  expect_type(results$count, "integer")
})
