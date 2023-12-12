#!/bin/bash

set -ex

HOSTS=""
#THREADS_PER_NODE=(1 8 16 32 64 128)
THREADS_PER_NODE=(32 64 128)
BLOCKSIZE_PER_TASK="16g"
#TRANSFER_SIZES=("128k" "1m" "16m" "64m")
TRANSFER_SIZES=("16m" "64m")
TEST_DIRECTORY="/mnt/cstor1/ccarlson/flash"
TEST_FILE="testfile"

# Sequential Write
function seq_write {
  # Run FIO
  THREADS=$1
  echo "fio seq write"
}

# Random Write
function rand_write {
  THREADS=$1

  fio

  OUT_FILE="$OUT_DIR/rand_write_${TRANSFER_SIZE}_${THREADS}.csv"
  mpirun --allow-run-as-root --machinefile $MACHINE_FILE --mca btl_tcp_if_include eth0 -np $(( THREADS * TOTAL_HOSTS )) --map-by "node" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -e -w -z -k -o $TEST_DIRECTORY/$TEST_FILE \
    -O summaryFile=$OUT_FILE -O summaryFormat=CSV
  RESULTS=$(tail -1 $OUT_FILE)
  echo -e "rand_write,$THREADS,$TRANSFER_SIZE,$RESULTS" >> $OUT_DIR/results.csv
}

# Sequential Read
function seq_read {
  THREADS=$1

  fio \
    --name=benchmark_128k \
    --name=benchmark_1m \
    --name=benchmark_16m \
    --name=benchmark_64m \
    seq_read.fio

  TRANSFER_SIZE=$1
  THREADS=$2
  OUT_FILE="$OUT_DIR/seq_read_${TRANSFER_SIZE}_${THREADS}.csv"
  mpirun --allow-run-as-root --machinefile $MACHINE_FILE --mca btl_tcp_if_include eth0 -np $(( THREADS * TOTAL_HOSTS )) --map-by "node" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -r -k -o $TEST_DIRECTORY/$TEST_FILE \
    -O summaryFile=$OUT_FILE -O summaryFormat=CSV
  RESULTS=$(tail -1 $OUT_FILE)
  echo -e "seq_read,$THREADS,$TRANSFER_SIZE,$RESULTS" >> $OUT_DIR/results.csv
}

# Random Read
function rand_read {
  THREADS=$1

  TRANSFER_SIZE=$1
  THREADS=$2
  OUT_FILE="$OUT_DIR/rand_read_${TRANSFER_SIZE}_${THREADS}.csv"
  mpirun --allow-run-as-root --machinefile $MACHINE_FILE --mca btl_tcp_if_include eth0 -np $(( THREADS * TOTAL_HOSTS )) --map-by "node" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -r -z -k -o $TEST_DIRECTORY/$TEST_FILE \
    -O summaryFile=$OUT_FILE -O summaryFormat=CSV
  RESULTS=$(tail -1 $OUT_FILE)
  echo -e "rand_read,$THREADS,$TRANSFER_SIZE,$RESULTS" >> $OUT_DIR/results.csv
}

[ $# -ne 1 ] && echo -e "Usage:\n\tbenchmark.sh <output_directory>\n" && exit 1

OUT_DIR=$1
mkdir -p $OUT_DIR

echo -e "access_type,threads,transfer_size,access,bw(MiB/s),IOPS,Latency,block(KiB),xfer(KiB),open(s),wr/rd(s),close(s),total(s),numTasks,iter" \
  > $OUT_DIR/results.csv

for THREADS in ${THREADS_PER_NODE[@]}; do
  for TRANSFER_SIZE in ${TRANSFER_SIZES[@]}; do
    echo -e "\nRunning benchmark with transfer size of $TRANSFER_SIZE, and $THREADS threads\n"
    seq_write $TRANSFER_SIZE $THREADS
    seq_read $TRANSFER_SIZE $THREADS
    rand_write $TRANSFER_SIZE $THREADS
    rand_read $TRANSFER_SIZE $THREADS
  done
done
