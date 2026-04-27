#!/bin/bash -ue
JW26ADS8192 gene_regulation_summary  \
--input        dge_shrink.rds dge_shrink.tsv         \
--output       ./results/            \
--p_threshold  0.05 \
--fc_threshold 0.5
