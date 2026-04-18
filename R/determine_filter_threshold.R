# R/data.R

#'  The filtering diagnostics evaluate how the pre-filtering threshold (minimum count per group) affects the number of discoveries, enabling users to choose an informed threshold
#'
#' @param se_ln A SummarizedExperiment object
#' @param count_thresholds minimum threshold of gene counts (default: 'c(0, 1, 5, 10, 20, 50, 100, 200, 500)')
#' @param assay_name Name of assay to use (default: "counts")
#' @param ref_level sets the reference to a specific cell type (default: "Tconv")
#' @param p_threshold The threshold that defines a gene's significance (default: 0.05)
#' @param group_var determines the column to categorization
#'
#' @return A dataframe summarizing the number of significant genes per threshold
#'
#' @importFrom  SummarizedExperiment assay colData
#' @importFrom  DESeq2 DESeqDataSet DESeq results
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#' library(DESeq2)
#' data(example_se)
#'
#' # Step 1: Evaluate how model preforms using different threshold values
#' example_se_filtering_assessment<- determine_filter_threshold(se_ln = example_se,count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500), assay_name = "counts", ref_level = "Tconv", group_var = "cell_type", p_threshold = 0.05)
#'
#' # Step 2: Choose the optimal min gene count threshold per gene and insert into all functions. `min_count_per_group` (default: 10)
#'
determine_filter_threshold<- function(se_ln, count_thresholds = c(0, 1, 5, 10, 20, 50, 100, 200, 500),
                                      assay_name = "counts", ref_level = "Tconv",
                                      group_var = "cell_type", p_threshold = 0.05){
  #if `group_var` isn't in se, throw error
  if (!group_var %in% colnames(colData(se_ln))){
    stop(sprintf(
      "invalid group_var: %s. Available columns are: %s",
      group_var,
      paste(colnames(colData(se_ln)), collapse = ", ")
    ))
    }
  #else, run analysis
  else{
    #if ref_level isn't a category in group_var, throw error
    if (!ref_level %in% unique(se_ln[[group_var]])){
      stop(sprintf("invalid ref_level: %s. Available ref_level are: %s",
                   ref_level,
                   paste(unique(se_ln[[group_var]]), collapse = ", ")))
      }
    #else, proceed
    else{
    filtering_diag <- data.frame(threshold = count_thresholds, n_tested = NA_integer_, n_significant = NA_integer_)
  se_ln[[group_var]] <- as.factor(se_ln[[group_var]])
  for (j in seq_along(count_thresholds)) {
    thresh <- count_thresholds[j]
    keep_t <- rowSums(assay(se_ln, assay_name)) >= thresh
    if (sum(keep_t) < 2) {
      filtering_diag$n_tested[j] <- sum(keep_t)
      filtering_diag$n_significant[j] <- 0
      next
    }
    design_formula <- as.formula(paste('~', group_var))
    dds_t <- DESeqDataSet(se_ln[keep_t, ], design = design_formula)
    dds_t[[group_var]] <- relevel(dds_t[[group_var]], ref = ref_level)
    dds_t <- DESeq(dds_t, quiet = TRUE)
    res_t <- results(dds_t, alpha = p_threshold)
    filtering_diag$n_tested[j] <- sum(keep_t)
    filtering_diag$n_significant[j] <- sum(res_t$padj < p_threshold, na.rm = TRUE)
  }
#output returns as a dataframe
  return(filtering_diag)
  }
  }
}
