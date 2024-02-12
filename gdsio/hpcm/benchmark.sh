#!/bin/bash

# Benchmark script to run gdsio using a .gdsio job file

# Make sure you've added gdsio to your $PATH.
# It can usually be found under /usr/local/cuda-<version>/gds/tools
if ! command -v gdsio &> /dev/null; then
  echo "'gdsio' command not found. Make sure CUDA toolkit is installed, and "
  echo "/usr/local/cuda-<version>/gds/tools has been added to your \$PATH var."
  exit 1
fi

# Use a custom cufile.json instead of the default /etc/cufile.json
export CUFILE_ENV_PATH_JSON="/home/hpcd/carlsonc/gdsio/cufile.json"
export NUM_GDS_THREADS_PER_GPU=8
export GDSIO_OUTPUT_ROOT="/lus/aiholus1/flash/carlsonc"

gdsio write.gdsio
