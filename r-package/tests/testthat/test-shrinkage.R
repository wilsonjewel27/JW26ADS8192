#test_shrinkage


test_that("All values in the dataframe (expect for gene name and fcSE) are numeric", {
  data(example_se)

#rerun previous functions
  # Step 1: Evaluate how model preforms using different threshold values and choose a threshold
  example_se_filtering_assessment<- determine_filter_threshold(example_se)
  # Step 2; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
  # Step 3: Run the DESeq2 pipeline to get differential gene expression results
  se_dge<- run_DESeq2(se_filtered)

  results <- log2_shrinkage(dds = se_dge, shrinkage = "apeglm")

  expect_true(is.numeric(results$log2FoldChange))
  expect_true(is.numeric(results$pvalue))
  expect_true(is.numeric(results$padj))
})
