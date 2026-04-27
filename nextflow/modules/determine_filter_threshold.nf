process determine_filter_threshold{
    container "hw2-jewel:0.0.1"
    publishDir params.outdir, mode: 'copy'

    input:
    path counts
    path meta

    output:
    path 'results/filtering_analysis.tsv'

    script:
    """
    JW28ADS8192 determine_filter_threshold --counts ${counts} --meta ${meta} --output ./results/
    
    """
}