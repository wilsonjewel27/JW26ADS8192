# R/data.R

#' Applies log2fold-change shrinkage for more reliable effect-size estimates
#'
#' @param dds The results of 'DESeq2_function'
#' @param shrinkage The estimator used to assess the glm coefficeints (default: "apeglm")
#'
#' @return Dataframe of log2fold-changed shrinkage applied to ds
#'
#' @importFrom SummarizedExperiment assay
#' @importFrom DESeq2 lfcShrink
#' @importFrom apeglm apeglm
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#' library(DESeq2)
#' library(apeglm)
#'
#' tissueTreg_filter_DESeq2_shrink <- log2_shrinkage(tissueTreg_filter_DESeq2)
#'
log2_shrinkage<- function(dds, shrinkage = "apeglm"){
  coef_name <- resultsNames(dds)[2]                                # "cell_type_Treg_vs_Tconv"
  res_shrunk <- lfcShrink(dds, coef = coef_names, type = shrinkage)
  res_df <- as.data.frame(res_shrunk)
  res_df$gene <- rownames(res_df)
  return(res_df)
}
