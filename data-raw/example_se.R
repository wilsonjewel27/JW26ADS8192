#data-raw/example_se.R-creates example_se dataset


#create a small SummarizedExperiment
library(SummarizedExperiment)
set.seed(13)

#500 genes, 20 samples
n_genes <- 500
n_cells <- 20

#stimulate counts (negative binomial-ish)
counts <- matrix(
  rpois(n_genes * n_cells, lambda = 100),
  nrow <- n_genes,
  ncol <- n_cells
)
rownames(counts) <- paste0("gene", seq_len(n_genes))
colnames(counts) <- paste0("sample", seq_len(n_cells))

#Create different T cell classes: first 75 are Treg
cell_class<- rep(c("Treg", "Tconv"), each = n_cells/2)
counts[1:75, cell_class == "Treg"] <- counts[1:75, cell_class =="Treg"] * 2

#cell Metadata
cell_data <- data.frame(
  cell_id = colnames(counts),
  cell_class = cell_class,
  batch = rep(c("A", "B"), length.out = n_cells),
  row.names = colnames(counts)
)

#gene metadata
gene_data <- data.frame(
  gene_id = rownames(counts),
  gene_symbol = paste0("SYM", seq_len(n_genes)),
  row.names = rownames(counts)
)

#Create SummarizedExperiment
example_se <- SummarizedExperiment(
  assays = list(counts = counts),
  colData = cell_data,
  rowData = gene_data
)

#Save to data/
usethis::use_data(example_se, overwrite = TRUE)

