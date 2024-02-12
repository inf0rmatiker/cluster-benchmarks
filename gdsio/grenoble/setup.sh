#!/bin/bash

GDSIO_OUTPUT_ROOT="/e1000/ccarlson/gds"
HOSTS=("o186i221" "o186i222")
NUM_GPUS=$(nvidia-smi -L | wc -l)

# Establish gpu directories
if [[ ! -d $GDSIO_OUTPUT_ROOT ]]; then
  echo "Creating gdsio output directory $GDSIO_OUTPUT_ROOT"
  mkdir -m 777 -p $GDSIO_OUTPUT_ROOT
fi

for HOST in ${HOSTS[@]}; do
  mkdir -m 777 $GDSIO_OUTPUT_ROOT/$HOST

  for i in $(seq 0 $NUM_GPUS); do
    if [[ ! -d $GDSIO_OUTPUT_ROOT/$HOST/gpu$i ]]; then
      echo "No $GDSIO_OUTPUT_ROOT/$HOST/gpu$i exists, creating it..."
      mkdir -m 777 -p $GDSIO_OUTPUT_ROOT/$HOST/gpu$i
    fi
  done
done
