#!/bin/bash -ue
JW26ADS8192 log2_shrinkage     \
--input     se_dge.rds          \
--output    ./results/         \
--shrinkage apeglm
