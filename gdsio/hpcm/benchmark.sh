#!/bin/bash

# Benchmark script to run gdsio using a .gdsio job file

# Make sure you've added gdsio to your $PATH.
# It can usually be found under /usr/local/cuda-<version>/gds/tools

# Use a custom cufile.json instead of the default /etc/cufile.json
export CUFILE_ENV_PATH_JSON="/home/hpcd/carlsonc/gdsio/cufile.json"
export NUM_GDS_THREADS_PER_GPU=8

gdsio write.gdsio
