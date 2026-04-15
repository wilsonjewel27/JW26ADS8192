# R/data.R

#' Filter genes with low expression
#'
#' @param se A SummarizedExperiment object
#' @param min_count_per_group The minimum threshold of gene count (default: 10)
#' @param assay_name Name of assay to use (default: "counts")
#'
#' @return A SummarizedExperiment subset of genes with greater than n counts
#'
#' @importFrom SummarizedExperiment assay
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#'
#' tissueTreg_filtered<- filter_low_exp_genes(tissueTreg, min_count_per_group = 10)
filter_low_exp_genes <- function(se, min_count_per_group=10, assay_name = "counts"){
  keep_genes <- rowSums(assay(se_ln, assay_name)) >= min_count_per_group
  se_ln <- se_ln[keep_genes, ]
  cat("Genes after filtering:", nrow(se_ln), "\n")
  return(se_ln)
}
