process filter_low_exp_genes{
    container "hw2-jewel:0.0.3"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path counts
    path metadata

    output:
    path 'results/se_filtered.rds'

    script:
    """
    JW26ADS8192 filter_low_exp_genes --counts ${counts} --meta ${metadata} --output ./results/ --min_count_per_group ${params.min_count_per_group}
    
    """
}