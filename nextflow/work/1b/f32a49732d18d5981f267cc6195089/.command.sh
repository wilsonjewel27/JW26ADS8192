#!/bin/bash -ue
JW26ADS8192 filter_low_exp_genes --counts example_counts.tsv --meta example_meta.tsv --output ./results/ --min_count_per_group 10
