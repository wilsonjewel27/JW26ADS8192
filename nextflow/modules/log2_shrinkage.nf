process log2_shrinkage{
    container "hw2-jewel:0.0.3"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path se_dge

    output:
    path 'results/dge_shrink.rds'

    script:
    """
    JW26ADS8192 log2_shrinkage     \\
    --input     ${se_dge}          \\
    --output    ./results/         \\
    --shrinkage ${params.shrinkage} 

    
    """
}