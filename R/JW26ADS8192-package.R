#' @keywords internal
"JW26ABDS8192"

"Provides a tool for differential gene analysis of lymph node regulatory T cells (Tregs) and conventional T cells (Tconv) isolated from four mouse tissues (fat, liver, lymph node, and skin).
Tool includes functions that:
  (1) Computes the minimun threhold of gene counts per cell
  (2) filtering low expression gene counts,
  (3) preforms DESeq2 differential expression analysis,
  (4) applies log2fold-change shrinkage to the DESeq2 results,
  (5) summarizes the number of up/down/non-significant genes at given thresholds,
  (6) visualizes results as a volcano plot, and
  (7) exports the results to TSV, pdf, and png files."
