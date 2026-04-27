#!/bin/bash -ue
JW26ADS8192 run_DESeq2          \
--input     se_filtered.rds      \
--output    ./results/          \
--group_var cell_type \ 
--ref_level Tconv
