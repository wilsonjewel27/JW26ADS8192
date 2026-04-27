process run_DESeq2{
    container "hw2-jewel:0.0.3"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path se_filtered

    output:
    path 'results/se_dge.rds'

    script:
    """
    JW26ADS8192 run_DESeq2          \\
    --input     ${se_filtered}      \\
    --output    ./results/          \\
    --group_var ${params.group_var} \\
    --ref_level ${params.ref_level}
    
    """
}