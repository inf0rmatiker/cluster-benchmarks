#!/bin/bash

ACCESS_TYPES=("seq_write" "rand_write" "seq_read" "rand_read")
THREADS_PER_NODE=(1 8 16 32 64 128)
TRANSFER_SIZES=("128k" "1m" "16m" "64m")

echo -e "access_type,threads,transfer_size,access,bw(MiB/s),IOPS,Latency,block(KiB),xfer(KiB),open(s),wr/rd(s),close(s),total(s),numTasks,iter"

for THREADS in ${THREADS_PER_NODE[@]}; do
  for TRANSFER_SIZE in ${TRANSFER_SIZES[@]}; do
    for ACCESS_TYPE in ${ACCESS_TYPES[@]}; do
      FILENAME="${ACCESS_TYPE}_${TRANSFER_SIZE}_${THREADS}.csv"
      LINE=$(tail -1 $FILENAME)
      echo -e "$ACCESS_TYPE,$THREADS,$TRANSFER_SIZE,$LINE"
    done
  done
done