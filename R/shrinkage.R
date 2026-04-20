# R/data.R

#' Apply log2fold-change shrinkage for more reliable effect-size estimates
#'
#' @param dds The results of 'DESeq2_function'
#' @param shrinkage The estimator used to assess the glm coefficeints (default: "apeglm")
#'
#' @return Dataframe of log2fold-changed shrinkage applied to ds
#'
#' @importFrom SummarizedExperiment assay colData
#' @importFrom DESeq2 lfcShrink resultsNames
#' @importFrom apeglm apeglm
#' @export
#'
#' @examples
#' data(example_se)
#'
#' # Step 1; Filter low expression genes
#' se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#'
#' # Step 2: Run the DESeq2 pipeline to get differential gene expression results
#'  se_dge<- run_DESeq2(se_filtered)
#'
#' # Step 3: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
#' se_dge_shrink <- log2_shrinkage(dds = se_dge, shrinkage = "apeglm")
#'
log2_shrinkage<- function(dds, shrinkage = "apeglm"){
  coef_name <- resultsNames(dds)[2]
  res_shrunk <- lfcShrink(dds, coef = coef_name, type = shrinkage)
  res_df <- as.data.frame(res_shrunk)
  res_df$gene <- rownames(res_df)
  return(res_df)
}
