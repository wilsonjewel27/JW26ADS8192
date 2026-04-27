process gene_regulation_summary{
    container "hw2-jewel:0.0.3"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path dge_shrink

    output:
    tuple path('results/gene_reg_summary.rds'), path('results/gene_reg_summary.tsv')

    script:
    """
    JW26ADS8192 gene_regulation_summary  \\
    --input        ${dge_shrink}         \\
    --output       ./results/            \\
    --p_threshold  ${params.p_threshold} \\
    --fc_threshold ${params.fc_threshold}

    
    """
}