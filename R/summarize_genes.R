# R/data.R

#' Summarize the number of significantly non-significant(ns)/up/down genes at given thresholds
#'
#' @param p_threshold The p-value that determines the number for genes per category(default: 0.05)
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param fc_threshold (default = 0.5)
#'
#' @return Summary of non-significant(ns)/up/down genes
#'
#' @importFrom SummarizedExperiment assay
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#'
#' DESeq2_gene_reg_summary<- gene_regulation_summary(tissueTreg_filter_DESeq2_shrink)
#'
gene_regulation_summary<- function(res_df, p_threshold = 0.05, fc_threshold =  0.5){
  res_df$direction <- "ns"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange >  fc_threshold] <- "up"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange <  -fc_threshold] <- "down"

  summary_df <- as.data.frame(table(res_df$direction))
  colnames(summary_df) <- c("direction", "count")
  return(summary_df)
}
