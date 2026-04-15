#' Example SummarizedExperiment for testing
#'
#' A small SummarizedExperiment with 500 genes and 20 cells.
#' The first 75 genes are "Treg" cells, and the remainder are "Tconv".
#'
#' @format A SummarizedExperiment with:
#' \describe{
#'   \item{assays}{counts - raw count matrix}
#'   \item{colData}{sample_id, cell_class (Treg/Tconv), batch (A/B)}
#'   \item{rowData}{gene_id, gene_symbol}
#' }
#'
#' @source Simulated data for teaching purposes
#'
#' @examples
#' library(SummarizedExperiment)
#' data(example_se)
#' example_se
#' colData(example_se)
"example_se"
