process log2_shrinkage{
    container "hw2-jewel:0.0.1"
    publishDir params.outdir, mode: 'copy'

    input:
    path se_dge

    output:
    path 'results/dge_shrink.rds'
    path 'results/dge_shrink.tsv'

    script:
    """
    JW28ADS8192 log2_shrinkage     \\
    --input     ${se_dge}          \\
    --output    ./results/         \\
    --shrinkage ${params.shrinkage} 

    
    """
}