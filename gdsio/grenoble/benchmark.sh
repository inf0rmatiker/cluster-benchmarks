#!/bin/bash

# Benchmark script to run gdsio using a .gdsio job file
[[ $# -ne 1 ]] && echo "Usage: ./benchmark.sh write.gdsio" && exit 1

# Use a custom cufile.json instead of the default /etc/cufile.json
export CUFILE_ENV_PATH_JSON="/home/ccarlson/gds/cufile.json"

GDSIO="/usr/local/cuda-12.3/gds/tools/gdsio"
JOBFILE=$1
JOB_NAME=${JOBFILE%.gdsio}  # remove .gdsio suffix
THREADS_ARRAY=(1 4 8 16 24)
RESULTS_DIR="multi_node_results"
HOSTNAME=$(hostname)
RESULTS_FILE="${RESULTS_DIR}/${HOSTNAME}_${JOB_NAME}_results.out"

rm -f $RESULTS_FILE
for THREADS in ${THREADS_ARRAY[@]}; do
  echo "Results for $THREADS threads per GPU:" >> $RESULTS_FILE
  export NUM_GDS_THREADS_PER_GPU=$THREADS
  $GDSIO $JOBFILE >> $RESULTS_FILE
done