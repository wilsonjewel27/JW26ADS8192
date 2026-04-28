process generate_volcano{
    container "hw2-jewel:0.0.1"
    publishDir params.outdir, mode: 'copy'

    input:
    path dge_shrink

    output:
    path 'results/volcano_plot.rds'
    path 'results/volcano_plot.pdf'
    path 'results/volcano_plot.png'

    script:
    """
    JW28ADS8192 log2_shrinkage            \\
    --input        ${dge_shrink}          \\
    --output       ./results/             \\
    --p_threshold  ${params.p_threshold}  \\
    --fc_threshold ${params.fc_threshold} \\
    --set_title    "${params.set_title}"  \\
    --xlab         "${params.xlab}"

    
    """
}