#!/usr/bin/env Rapp
#| name: JW26ADS8192
#| title: JW26ADS8192 Differential Gene Expression with DESeq2
#| description: DESeq2 analysis for count matrix and sample metadata.

suppressPackageStartupMessages({
  library(JW26ADS8192)
  library(utils)
  library(stats)
  library(ggplot2)
  library(SummarizedExperiment)
  library(DESeq2)
  library(apeglm)
  library(rlang)
})

# Helper to read TSV/CSV (not exported; kept in CLI script)
read_data_file <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext == "csv") {
    utils::read.csv(path, row.names = 1, check.names = FALSE)
  } else {
    utils::read.table(path, sep = "\t", header = TRUE, row.names = 1,
                      check.names = FALSE)
  }
}

switch(
  "",
  #| title: Step 1 Determine Minimal Number of Gene Counts
  #| description: Determine optimal minimal gene count threshold.
  determine_filter_threshold = {
    #| description:  Path to count matrix TSV or CSV.
    #| short: c
    counts <- ""

    #| description: Path to sample metadata
    #| short: m
    meta <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: the tested minimun gene counts
    #| short: t
    count_thresholds <- "0,1,5,10,20,50,100,200,500"

    #| description: Metadata column for grouping e.g. cell_type
    #| short: g
    group_var <- "cell_type"

    #| description: Referefence level for comparison e.g. Tconv
    #| short: r
    ref_level <- "Tconv"

    #| description: Name of assay to use e.g. counts
    #| short: a
    assay_name <- "counts"

    #| description: Adjusted p-value threshold. default 0.05
    #| short:  p
    p_threshold <- 0.05

    #Validation
    if (meta == "" || counts == "" || output == "" || group_var == "" || ref_level == "" || assay_name == ""){
      stop ("--meta, --count, --output, --group_var, --ref_level, --assay_name are required", call. = FALSE)
    }

    if (!file.exists(counts)){
      stop("File not found: ", counts, call. = FALSE)
    }

    if (!file.exists(meta)){
      stop("File not found: ", meta,   call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    # Parse count_thresholds from comma-separated string to numeric vector
    count_thresholds <- as.numeric(strsplit(count_thresholds, ",")[[1]])

    # Read inputs
    counts_df <- read_data_file(counts)
    meta_df <- read_data_file(meta)

    # Run analysis using package core functions
    se <- SummarizedExperiment(
      assays = list(counts = as.matrix(counts_df)),
      colData = meta_df
    )

    #Run Filtering Threshold Analysis
    message("Running filter threshold analysis...")
    results <- determine_filter_threshold(
      se_ln = se,
      group_var = group_var,
      ref_level = ref_level,
      assay_name = assay_name,
      p_threshold = p_threshold
    )

    #export results as
    out_file <- file.path(output, "filtering_analysis.tsv")
    write.table(results, out_file,
                sep = "\t", row.names = FALSE, quote = FALSE)

    #confirmations
    message("Saved: ", out_file)
    message("Done.")
  },

  #| title: Step 2 Filter Low Expression Genes
  #| description: Filter low expression genes by count threshold.
  filter_low_exp_genes = {
    #| description: Path to count matrix TSV or CSV.
    #| short: c
    counts <- ""

    #| description: Path to sample metadata
    #| short: m
    meta <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: Min count threshold. default 10.
    #| short: e
    min_count_per_group <- 10

    #| description: Name of assay to use e.g. counts
    #| short: a
    assay_name <- "counts"

    #Validation
    if (counts == "" || meta == "" || output == "" || assay_name == ""){
      stop ("--input, --output, --assay_name are required", call. = FALSE)
    }
    if (!file.exists(counts)){
      stop("File not found: ", counts, call. = FALSE)
    }
    if (!file.exists(meta)){
      stop("File not found: ", meta,   call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    # Read inputs
    counts_df <- read_data_file(counts)
    meta_df <- read_data_file(meta)

    # Run analysis using package core functions
    se <- SummarizedExperiment(
      assays = list(counts = as.matrix(counts_df)),
      colData = meta_df
    )

    #Filter low expression genes and save as se_filtered
    message("Filtering low expression genes...")
    se_filtered <- filter_low_exp_genes(
      se_ln = se,
      assay_name = assay_name,
      min_count_per_group = min_count_per_group
    )

    #save results as RDS
    saveRDS(se_filtered, file.path(output, "se_filtered.rds"))

    #confirmations
    message("Saved as RDS")
    message("Done.")
  },

  #| title: Step 3 Preform DESeq2 analysis
  #| description: Run DESeq2 differential expression analysis.
  run_DESeq2 = {
    #| description: Path to se_filtered
    #| short: i
    input <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: Metadata column for grouping e.g. cell_type
    #| short: g
    group_var <- "cell_type"

    #| description: Referefence level for comparison e.g. Tconv
    #| short: r
    ref_level <- "Tconv"

    #Validation
    if (input == "" || output == "" || group_var == "" || ref_level == ""){
      stop ("--input, --output, --group_var, --ref_level are required", call. = FALSE)
    }

    if (!file.exists(input)){
      stop( "File not found:", input, call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    #load SummarizedExperiment
    se_filtered <- readRDS(input)

    #Run DESeq2 analysis
    message("Running DESeq2 analysis...")
    se_dge <- run_DESeq2(
      se_ln = se_filtered,
      group_var = group_var,
      ref_level = ref_level
    )

    #save results as RDS
    saveRDS(se_dge, file.path(output, "se_dge.rds"))

    #confirmations
    message("Saved as RDS")
    message("Done.")

  },

  #| title: Step 4 Log2fold-Change Shrinkage
  #| description: Apply log2fold-change shrinkage.
  log2_shrinkage = {
    #| description: Path to se_dge
    #| short: i
    input <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: GLM estimator. default apeglm
    #| short: s
    shrinkage <-  "apeglm"

    #Validation
    if (input == "" || output == "" || shrinkage == ""){
      stop ("--input, --output, --shrinkage are required", call. = FALSE)
    }

    if (!file.exists(input)){
      stop( "File not found:", input, call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    #load DESeqDataSet
    se_dge <- readRDS(input)

    #Run log2fold-change shrinkage
    message("Applying Log2fold-Change Shrinkage...")
    se_dge_shrink <- log2_shrinkage(
      dds = se_dge,
      shrinkage = shrinkage
    )

    #save results as RDS
    saveRDS(se_dge_shrink, file.path(output, "dge_shrink.rds"))

    #export table as tsv
    out_file <- file.path(output, "dge_shrink.tsv")
    write.table(se_dge_shrink, out_file,
                sep = "\t", row.names = FALSE, quote = FALSE)

    #confirmations
    message("Saved: ", out_file)
    message("Done.")
  },

  #| title: Step 5 Intrepret Gene Regulation
  #| description: Summarize up, down and non-significant genes.
  gene_regulation_summary = {
    #| description: Path to se_dge_shrink
    #| short: i
    input <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: Adjusted p-value threshold. default 0.05
    #| short: p
    p_threshold <- 0.05

    #| description: fold change threshold. default 0.5
    #| short: f
    fc_threshold <-  0.5

    #Validation
    if (input == "" || output == "" ){
      stop ("--input, --output, --p_threshold, --fc_threshold are required", call. = FALSE)
    }

    if (!file.exists(input)){
      stop( "File not found:", input, call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    #load  shrinkage dataframe
    se_dge_shrink <- readRDS(input)

    #Summarize Gene Regulation
    message("Summarizing gene regulation...")
    DESeq2_gene_reg_summary <- gene_regulation_summary(
      res_df = se_dge_shrink,
      fc_threshold =  fc_threshold,
      p_threshold = p_threshold
    )

    #save results as RDS
    saveRDS(DESeq2_gene_reg_summary, file.path(output, "gene_reg_summary.rds"))

    #export table as tsv
    out_file <- file.path(output, "gene_reg_summary.tsv")
    write.table(DESeq2_gene_reg_summary, out_file,
                sep = "\t", row.names = FALSE, quote = FALSE)

    #confirmations
    message("Saved: ", out_file)
    message("Done.")
  },

  #| title: Step 6 Visualize Expression in a Volcano Plot
  #| description: Generate a volcano plot of DE results.
  generate_volcano = {
    #| description: Path to se_dge_shrink
    #| short: i
    input <- ""

    #| description: output directory
    #| short: o
    output <- ""

    #| description: Adjusted p-value threshold. default 0.05
    #| short: p
    p_threshold <- 0.05

    #| description: fold change threshold. default 0.5
    #| short: f
    fc_threshold <-  0.5

    #| description: Plot title. default Volcano Plot
    #| short: t
    set_title <- "Volcano Plot: Lymph Node Treg vs Tconv"

    #| description: X-axis label. default log2 Fold Change
    #| short: x
    xlab <- "log2 Fold Change (Treg vs Tconv)"

    #Validation
    if (input == "" || output == "" ||set_title == "" || xlab == ""){
      stop ("--input, --output, --p_threshold, --fc_threshold, --set_title, --xlab are required", call. = FALSE)
    }

    if (!file.exists(input)){
      stop( "File not found:", input, call. = FALSE)
    }

    if (!dir.exists(output))dir.create(output, recursive = TRUE)

    #load shrinkage dataframe
    se_dge_shrink <- readRDS(input)

    #generate the volcano plot
    message("Generating volcano plot...")
    example_se_volcano <- generate_volcano(
      res_df = se_dge_shrink,
      fc_threshold =  fc_threshold,
      p_threshold = p_threshold,
      set_title = set_title,
      xlab = xlab
    )

    #save results as RDS
    saveRDS(example_se_volcano, file.path(output, "volcano_plot.rds"))

    #export results as pdf and png
    ggsave(filename="volcano_plot.pdf", plot=example_se_volcano, width=5, height = 5, path = output)
    ggsave(filename="volcano_plot.png",plot=example_se_volcano, width=5, height = 5, units = "in", dpi = 300, path = output)

    #confirmations
    message("Saved: ", out_file)
    message("Done.")
  }
)
