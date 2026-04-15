# R/data.R

#' Preform Differential Gene Analysis
#'
#' @param se A SummarizedExperiment object
#' @param ref_level sets the reference to a specific cell type (default: "Tconv")
#'
#' @return The results of the Differential Gene Analysis between cell_type
#'
#'  @importFrom SummarizedExperiment assay
#'  @export
#'
#'  @examples
#'  library(SummarizedExperiment)

#'  tissueTreg_filter_DESeq2<- DESeq2_function(example_se)
#'
DESeq2_function <- function(se, ref_level = "Tconv" ){
  dds <- DESeq2::DESeqDataSet(se, design = ~ cell_type)
  dds$cell_type <- relevel(dds$cell_type, ref = ref_level)
  dds <- DESeq2::DESeq(dds)
  return(dds)
}
