# R/data.R

#'  The filtering diagnostics evaluate how the pre-filtering threshold (minimum count per group) affects the number of discoveries, enabling users to choose an informed threshold
#'
#' @param se A SummarizedExperiment object
#' @param count_thresholds minimum threshold of gene counts (default: 'c(0, 1, 5, 10, 20, 50, 100, 200, 500)')
#' @param assay_name Name of assay to use (default: "counts")
#' @param ref_level sets the reference to a specific cell type (default: "Tconv")
#' @param p_threshold The threshold that defines a gene's significance (default: 0.05)
#'
#' @return A dataframe summarizing the number of significant genes per threshold
#'
#' @importFrom  SummarizedExperiment assay
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#'
#' tissueTreg_filtering_assessment<- assess_filtering(example_se)
#'
assess_filtering<- function(se, count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500), assay_name = "counts", ref_level = "Tconv", p_threshold = 0.05){
  filtering_diag <- data.frame(threshold = count_thresholds, n_tested = NA_integer_, n_significant = NA_integer_)
  for (j in seq_along(count_thresholds)) {
    thresh <- count_thresholds[j]
    keep_t <- rowSums(assay(se, assay_name)) >= thresh
    if (sum(keep_t) < 2) {
      filtering_diag$n_tested[j] <- sum(keep_t)
      filtering_diag$n_significant[j] <- 0
      next
    }
    dds_t <- DESeqDataSet(se[keep_t, ], design = ~ cell_type)
    dds_t$cell_type <- relevel(dds_t$cell_type, ref = ref_level)
    dds_t <- DESeq(dds_t, quiet = TRUE)
    res_t <- results(dds_t, alpha = p_threshold)
    filtering_diag$n_tested[j] <- sum(keep_t)
    filtering_diag$n_significant[j] <- sum(res_t$padj < p_threshold, na.rm = TRUE)
  }
  return(filtering_diag)
}
