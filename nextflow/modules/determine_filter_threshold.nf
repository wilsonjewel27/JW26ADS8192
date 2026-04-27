process determine_filter_threshold{
    container "hw2-jewel:0.0.3"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path counts
    path metadata

    output:
    path 'results/filtering_analysis.tsv'

    script:
    """
    JW26ADS8192 determine_filter_threshold \\
    --counts ${counts} \\
    --meta ${metadata} \\
    --output ./results/ 
    
    """
}