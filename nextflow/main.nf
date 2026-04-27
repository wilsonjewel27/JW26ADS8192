#!/usr/bin/env nextflow

// Pasted from:
// https://github.com/nextflow-io/training/blob/master/nextflow-run/1-hello.nf


// inputs
params.counts = 'counts.tsv'  
params.meta    = 'meta.tsv'
params.outdir  = './results'

// default specifications
params.min_count_per_group = 10
params. group_var          = 'cell-type'
params.re_level            = 'Tconv'
params.shrinkage           = 'apeglm'
params.p_threshold         = '0.05'
params.fc_threshold        = '0.5'
params.set_title           = 'Volcano Plot: Lymph Node Treg vs Tconv'
params.xlab                = 'log2 Fold Change (T-reg vs Tconv)'

// modules
include { determine_filter_threshold } from "./modules/determine_filter_threshold.nf"
include { filter_low_exp_genes }       from "./modules/filter_low_exp_genes.nf"
include { run_DESeq2 }                 from "./modules/run_DESeq2.nf"
include { log2_shrinkage }             from "./modules/log2_shrinkage.nf"
include { gene_regulation_summary }    from "./modules/gene_regulation_summary.nf"
include { generate_volcano }           from "./modules/generate_volcano.nf"

// workflow
workflow {
    main:
        // Student: you may need to adjust the following line based on the params (input argument) you have above
        ch_counts = channel.fromPath(params.counts,   checkIfExists: true)
        ch_meta   = channel.fromPath(params.metadata, checkIfExists: true)
        
        // Step 1: Review the results of filtering_analysis.tsv to pick the most optimal threshold value
        determine_filter_threshold(ch_counts, ch_meta)

        // Step 2: Use the previously determined value to replace 'min_count_per_group'. Default 'min_count_per_group' = 10
        filter_low_exp_genes(ch_counts, ch_meta)

        // Step 3: Run the Differential Analysis via DESeq2
        run_DESeq2(filter_low_exp_genes.out)

        // Step 4: Apply the Log2 Fold Change shrinkage for mroe reliable estimates
        log2_shrinkage(run_DESeq2.out)

        // Step 5: Summarize the amount of low, high, and non-singificant expression genes
        gene_regulation_summary(log2_shrinkage.out)

        // Step 6: Visulaize Results in a Volcano Plot
        generate_volcano(log2_shrinkage.out)

        // Student: if "your_package" needs more than one inputs, e.g., counts + metadata instead of just counts, you would do
        // ch_counts  = channel.fromPath(params.counts, checkIfExists: true)
        // ch_meta    = channel.fromPath(params.metadata, checkIfExists: true)
        // your_package(ch_counts, ch_meta)


    publish:
        results = generate_volcano.out
}

output {
    results {
        path params.outdir
        mode 'copy'
    }
}
