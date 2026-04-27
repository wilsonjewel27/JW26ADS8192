process gene_regulation_summary{
    container "hw2-jewel:0.0.1"
    publishDir params.outdir, mode: 'copy'

    input:
    path dge_shrink

    output:
    path 'results/gene_reg_summary.rds'
    path 'results/gene_reg_summary.tsv'

    script:
    """
    JW28ADS8192 log2_shrinkage           \\
    --input        ${dge_shrink}         \\
    --output       ./results/            \\
    --p_threshold  ${params.p_threshold} \\
    --fc_threshold ${params.fc_threshold}

    
    """
}