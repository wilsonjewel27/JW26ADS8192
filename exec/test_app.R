#| name: JW26ADS8192
#| title: JW26ADS8192 Differential Expression with DESeq2
#| description: DESeq2 analysis for SummarizedExperiment data.
suppressPackageStartupMessages({
  library(JW26ADS8192)
  library(SummarizedExperiment)
  library(DESeq2)
})
switch(
  "",
  #| title: Step 1: Determine Minimal Number of Gene Counts
  #| description: Determine the optimal minimal number of gene counts
  filter_threshold = {
    #| description: Path to count matrix
    #| short: c
    counts <- ""
    message("test")
  }
)
