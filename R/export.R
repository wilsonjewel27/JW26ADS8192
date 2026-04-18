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
#'
#' @importFrom ggplot2 ggsave
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(SummarizedExperiment)
#' library(DESeq2)
#' library(apeglm)
#'  data(example_se)
#'
#' # Step 1: Evaluate how model preforms using different threshold values and choose a threshold
#' example_se_filtering_assessment<- determine_filter_threshold(example_se)
#'
#' # Step 2; Filter low expression genes
#' se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#'
#' # Step 3: Run the DESeq2 pipeline to get differential gene expression results
#'  se_dge<- run_DESeq2(se_filtered)
#'
#' # Step 4: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
#' se_dge_shrink <- log2_shrinkage(se_dge)
#'
#' # Step 5: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
#' example_se_volcano<- generate_volcano(se_dge_shrink)
#'
#' # Step 6: Generate the regulation summary of the genes
#' DESeq2_gene_reg_summary<- gene_regulation_summary(se_dge_shrink)
#'
#' # Step 7: Evaluate how model preforms using different threshold values
#' example_se_filtering_assessment<- determine_filter_threshold(example_se)
#'
#' # Step 8: Export final results
#' example_se_exports<- export_outputs(res_df = se_dge_shrink, summary_df = DESeq2_gene_reg_summary, filtering_diag = example_se_filtering_assessment, volcano = example_se_volcano, output_dir = file.path(tempdir(), "de_output") )
#'
export_outputs<- function(res_df, summary_df, filtering_diag, volcano,
                          output_dir = file.path(tempdir(), "de_output")){
#initial check to see if everything was imported correctly
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  object_check <- list(
    res_df         = class(res_df)         == "data.frame",
    summary_df     = class(summary_df)     == "data.frame",
    filtering_diag = class(filtering_diag) == "data.frame",
    volcano        = inherits(volcano, "ggplot")
  )
#Identifies the failed objects
  failed <- names(object_check)[!unlist(object_check)]

  if (length(failed) > 0){
    stop(sprintf("Invalid object(s). The following arguments have incorrect format: %s",
                 paste(failed, collapse = ", ")))
    }
  else {
#Saves the inital pre-filtering threshold data as a table
    write.table(filtering_diag, file.path(output_dir, "filtering_diagnostics.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
#Saves the log2fold-change shrinkage DESeq2 data as a table
    write.table(res_df, file.path(output_dir, "de_results.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
#Saves the Gene Regulation Count data frame as a table
    write.table(summary_df, file.path(output_dir, "de_summary.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
#Saves the volcano plot as a pdf
    ggsave(filename="volcano_plot.pdf", plot=volcano, width=5, height = 5, path = output_dir)
#Saves the volcano plot as a png
    ggsave(filename="volcano_plot.png",plot=volcano, width=5, height = 5, units = "in", dpi = 300, path = output_dir)
    files <- list.files(output_dir, full.names = TRUE)
    message(sprintf( "Export complete. Files saved:\n%s",
                    paste(files, collapse = "\n")
  ))
}}
