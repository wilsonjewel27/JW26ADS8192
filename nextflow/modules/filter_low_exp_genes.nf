process filter_low_exp_genes{
    container "hw2-jewel:0.0.1"
    publishDir params.outdir, mode: 'copy'

    input:
    path counts
    path meta

    output:
    path 'results/se_filtered.tsv'

    script:
    """
    JW28ADS8192 filter_low_exp_genes --counts ${counts} --meta ${meta} --output ./results/ --min_count_per_group ${params.min_count_per_group}
    
    """
}