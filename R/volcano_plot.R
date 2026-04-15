# R/data.R

#' Visualize results as a volcano plot
#'
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param fc_threshold (default: 0.5)
#' @param xlab The label of the x-axis
#' @param set_title The title of the plot
#' @param p_threshold THe threshold that defines a gene's significance (default: 0.05)
#'
#' @return volcano pot with significant genes highlighted
#'
#' @importFrom SummarizedExperiment assay
#' @importFrom ggplot2 ggplot geom_point scale_color_manual theme_bw labs geom_vline geom_hline
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(SummarizedExperiment)
#'
#' tissueTreg_volcano<- generate_volcano(tissueTreg_filter_DESeq2_shrink)
#'
generate_volcano<- function(res_df, fc_threshold =  0.5, xlab = "log2 Fold Change (Treg vs Tconv)", set_title = "Volcano Plot - Lymph Node Treg vs Tconv", p_threshold = 0.05){
  res_df$neg_log10p <- -log10(res_df$pvalue)
  p <- ggplot(res_df, aes(x = log2FoldChange, y = neg_log10p, color = direction)) +
    geom_point(size = 0.8, alpha = 0.6) +
    scale_color_manual(values = c(down = "blue", ns = "grey70", up = "red")) +
    theme_bw(base_size = 14) +
    labs(x = xlab,
         y = expression(-log[10](p)),
         title = set_title) +
    geom_vline(xintercept = c(-fc_threshold, fc_threshold), lty = 2) +
    geom_hline(yintercept = -log10(p_threshold), lty = 2)
  return(p)
}
