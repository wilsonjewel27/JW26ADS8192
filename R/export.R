# R/data.R

#' Export differential expression results, summary counts, and filtering diagnostics to TSV files
#'
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param summary_df A data frame summarizing the number of non-significant(ns)/up/down genes
#' @param filtering_diag A data frame summarizing the number of significant genes per threshold
#' @param volcano Your choice of volcano plot
#' @param output_dir Directories where files will be written
#'
#' @return TSV files of differential expression results, summary counts, and filtering diagnostics
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(SummarizedExperiment)
#' library(DESeq2)
#' library(apeglm)
#'  data(example_se)
#'
#' # Step 1; Filter low expression genes
#' se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#'
#' # Step 2: Run the DESeq2 pipeline to get differential gene expression results
#'  se_dge<- run_DESeq2(se_filtered)
#'
#' # Step 3: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
#' se_dge_shrink <- log2_shrinkage(se_dge)
#'
#' # Step 4: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
#' example_se_volcano<- generate_volcano(se_dge_shrink)
#'
#' #Step 5: Generate the regulation summary of the genes
#' DESeq2_gene_reg_summary<- gene_regulation_summary(se_dge_shrink)
#'
#' # Step 6: Evaluate how model preforms using different threshold values
#' example_se_filtering_assessment<- assess_filtering(example_se)
#'
#' # Step 7: Export final results
#' example_se_exports<- export_outputs(res_df = se_dge_shrink, summary_df = DESeq2_gene_reg_summary, filtering_diag = example_se_filtering_assessment, volcano = example_se_volcano, output_dir = file.path("C:/Users/jwilso09/JW26ADS8192/test_1", "de_output") )
#'
export_outputs<- function(res_df, summary_df, filtering_diag, volcano = v_plot, output_dir = file.path( , "de_output")){
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  write.table(res_df, file.path(output_dir, "de_results.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(summary_df, file.path(output_dir, "de_summary.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(filtering_diag, file.path(output_dir, "filtering_diagnostics.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  ggsave(filename="volcano_plot.pdf", plot=volcano, width=5, height = 5, path = output_dir)
  ggsave(filename="volcano_plot.png",plot=volcano, width=5, height = 5, units = "in", dpi = 300, path = output_dir)
  return(list(
    files = list.files(output_dir),
    output_dir = output_dir))
}
