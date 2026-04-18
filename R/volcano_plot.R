# R/data.R

#' Visualize results as a volcano plot
#'
#' @param res_df Dataframe of log2fold-changed shrinkage applied to ds
#' @param fc_threshold (default: 0.5)
#' @param xlab The label of the x-axis
#' @param set_title The title of the plot
#' @param p_threshold The threshold that defines a gene's significance (default: 0.05)

#'
#' @return volcano pot with significant genes highlighted
#'
#' @importFrom SummarizedExperiment assay colData
#' @importFrom ggplot2 ggplot geom_point scale_color_manual theme_bw labs geom_vline geom_hline aes
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(SummarizedExperiment)
#' library(DESeq2)
#' library(apeglm)
#' data(example_se)
#'
#' # Step 1; Filter low expression genes
#' se_filtered<- filter_low_exp_genes(example_se, min_count_per_group = 10)
#'
#' # Step 2: Run the DESeq2 pipeline to get differential gene expression results
#'  se_dge<- run_DESeq2(se_filtered)
#'
#' # Step 3: Run the log2_shrinkage function on the results of the DESeq2 function to create more reliable estimates
#' se_dge_shrink <- log2_shrinkage(se_dge)
#'
#' # Step 4: Create a volcano plot of the gene expression using the results obtained from the log2_shrinkage function
#' example_se_volcano<- generate_volcano(res_df = se_dge_shrink, fc_threshold =  0.5, xlab = "log2 Fold Change (Treg vs Tconv)", set_title = "Volcano Plot - Lymph Node Treg vs Tconv", p_threshold = 0.05)
#'
generate_volcano<- function(res_df, fc_threshold =  0.5, xlab = "log2 Fold Change (Treg vs Tconv)",
                            set_title = "Volcano Plot - Lymph Node Treg vs Tconv", p_threshold = 0.05){
#re-create gene regulation summary df (with gene names)
  if (!all(c("padj", "log2FoldChange") %in% colnames(res_df))){
    stop("invalid dataframe. Must contain 'padj' and 'log2FoldChange' columns.")
  }
  else {
  res_df$direction <- "ns"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange >  fc_threshold] <- "up"
  res_df$direction[res_df$padj < p_threshold & res_df$log2FoldChange <  -fc_threshold] <- "down"
# ensures graphed values are numeric
  res_df$neg_log10p <- as.numeric(-log10(res_df$pvalue))
  res_df$log2FoldChange <- as.numeric(res_df$log2FoldChange)
#build the plot
  v_plot <- ggplot(res_df, aes(x = log2FoldChange, y = neg_log10p, color = direction)) +
    geom_point(size = 0.8, alpha = 0.6) +
    scale_color_manual(values = c(down = "blue", ns = "grey70", up = "red")) +
    theme_bw(base_size = 14) +
    labs(x = xlab,
         y = expression(-log[10](p)),
         title = set_title) +
    geom_vline(xintercept = c(-fc_threshold, fc_threshold), lty = 2) +
    geom_hline(yintercept = -log10(p_threshold), lty = 2)
  return(v_plot)
  }
}
