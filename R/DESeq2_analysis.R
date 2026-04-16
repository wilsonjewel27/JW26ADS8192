# R/data.R

#' Preform Differential Gene Analysis
#'
#' @param se_ln A SummarizedExperiment object
#' @param ref_level sets the reference to a specific cell type (default: "Tconv")
#' @param group_var determines the column to categorization
#'
#' @return The results of the Differential Gene Analysis between cell_type
#'
#' @importFrom SummarizedExperiment assay
#' @importFrom DESeq2 DESeqDataSet DESeq result
#' @export
#'
#' @examples
#' library(SummarizedExperiment)
#' library(DESeq2)
#' data(example_se)
#'
#' # Step 1; Filter low expression genes
#' se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#'
#' # Step 2: Run the DESeq2 pipeline
#' se_dge<- run_DESeq2(se_ln = se_filtered, group_var = "cell_type", ref_level = "Tconv")
#'
run_DESeq2 <- function(se_ln, group_var = "cell_type", ref_level = "Tconv" ){
  se_ln[[group_var]] <- as.factor(se_ln[[group_var]])
  se_ln[[group_var]] <- relevel(se_ln[[group_var]], ref = ref_level)
  design_formula <- as.formula(paste('~', group_var))
  dds <- DESeqDataSet(se_ln, design = design_formula)
  dds <- DESeq(dds)
  return(dds)
}
