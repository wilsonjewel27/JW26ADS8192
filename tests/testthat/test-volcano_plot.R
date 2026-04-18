#test-generate volcano


test_that("Output is ggplot", {
  data(example_se)

#rerun previous functions
  # Step 1; Filter low expression genes
  se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
  # Step 2: Run the DESeq2 pipeline to get differential gene expression results
  se_dge<- run_DESeq2(se_filtered)
  # Step 3: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
  se_dge_shrink <- log2_shrinkage(se_dge)

  expect_s3_class(
    generate_volcano(
      res_df = se_dge_shrink,
      fc_threshold =  0.5,
      xlab = "log2 Fold Change (Treg vs Tconv)",
      set_title = "Volcano Plot - Lymph Node Treg vs Tconv",
      p_threshold = 0.05)
                  , "ggplot")
})


test_that("invalid df error message works",{

# "corrupt" data
  bad_df <- data.frame(x = 1:5, y = 6:10)

  expect_error(generate_volcano(res_df = bad_df)
               , "invalid dataframe")
})
