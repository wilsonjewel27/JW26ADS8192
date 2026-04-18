#test-export

test_that("Invalid argument insertion error works", {
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
# Step 5: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
  example_se_volcano<- generate_volcano(se_dge_shrink)
# Step 6: Generate the regulation summary of the genes
  DESeq2_gene_reg_summary<- gene_regulation_summary(se_dge_shrink)
# Step 7: Evaluate how model preforms using different threshold values
  example_se_filtering_assessment<- determine_filter_threshold(example_se)

  #"corrupt" df to create an error
  table1 <- as.table(as.matrix(se_dge_shrink))
  table2 <- as.table(as.matrix(DESeq2_gene_reg_summary))

  expect_error(
    export_outputs(res_df = table1,
               summary_df = table2,
               filtering_diag = example_se_filtering_assessment,
               volcano = example_se_volcano,
               output_dir = file.path(tempdir(), "test2"), "Invalid object(s)"))
})

test_that("'Export Complete...' message prints after sucessful exportation",{
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
  # Step 5: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
  example_se_volcano<- generate_volcano(se_dge_shrink)
  # Step 6: Generate the regulation summary of the genes
  DESeq2_gene_reg_summary<- gene_regulation_summary(se_dge_shrink)
  # Step 7: Evaluate how model preforms using different threshold values
  example_se_filtering_assessment<- determine_filter_threshold(example_se)

expect_message(export_outputs(res_df = se_dge_shrink,
                            summary_df = DESeq2_gene_reg_summary,
                            filtering_diag = example_se_filtering_assessment,
                            volcano = example_se_volcano,
                            output_dir = file.path(tempdir(),
                                                   "test2"))
             , "Export complete")

})
