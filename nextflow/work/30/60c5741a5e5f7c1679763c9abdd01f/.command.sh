#!/bin/bash -ue
JW26ADS8192 generate_volcano            \
--input        dge_shrink.rds dge_shrink.tsv          \
--output       ./results/             \
--p_threshold  0.05  \
--fc_threshold 0.5 \
--set_title    "Volcano Plot: Lymph Node Treg vs Tconv"  \
--xlab         "log2 Fold Change (T-reg vs Tconv)"
