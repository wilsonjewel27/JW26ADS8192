# R/data.R

#' Export differential expression results, summary counts, and filtering diagnostics to TSV files
#'
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param summary_df A data frame summarizing the number of non-significant(ns)/up/down genes
#' @param filtering_diag A data frame summarizing the number of significant genes per threshold
#' @param output_dir Directories where files will be written
#'
#' @return TSV files of differential expression results, summary counts, and filtering diagnostics
#' @export
#'
#' @examples
#' export_results<- export_outputs( tissueTreg_filter_DESeq2_shrink, DESeq2_gene_reg_summary,  tissueTreg_filtering_assessment)
export_outputs<- function(res_df, summary_df, filtering_diag, output_dir = file.path(tempdir(), "de_output")){
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  write.table(res_df, file.path(output_dir, "de_results.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(summary_df, file.path(output_dir, "de_summary.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(filtering_diag, file.path(output_dir, "filtering_diagnostics.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  return(list(
    files = list.files(output_dir),
    output_dir = output_dir))
}
