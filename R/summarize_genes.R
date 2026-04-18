# R/data.R

#' Summarize the number of significantly non-significant(ns)/up/down genes at given thresholds
#'
#' @param p_threshold The p-value that determines the number for genes per category(default: 0.05)
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param fc_threshold (default = 0.5)
#'
#' @return Summary of non-significant(ns)/up/down genes
#'
#' @importFrom SummarizedExperiment assay colData
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#' library(DESeq2)
#' library(apeglm)
#' data(example_se)
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
#' #Step 4: Generate the regulation summary of the genes
#' DESeq2_gene_reg_summary<- gene_regulation_summary(res_df = se_dge_shrink, p_threshold = 0.05, fc_threshold =  0.5)
#'
gene_regulation_summary<- function(res_df, p_threshold = 0.05, fc_threshold =  0.5){
#create a new column in res_df
  res_df$direction <- "ns"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange >  fc_threshold] <- "up"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange <  -fc_threshold] <- "down"
#create a dataframe only describing the number of cells and regulation direction
  summary_df <- as.data.frame(table(res_df$direction))
  colnames(summary_df) <- c("direction", "count")
  return(summary_df)
}
