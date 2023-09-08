#!/bin/bash

IOR_BIN="$HOME/ior/src/ior"
MACHINE_FILE="machinefile.txt"
TOTAL_SLOTS=128
BLOCKSIZE_PER_TASK="16g"
TRANSFER_SIZES="128k 1m 16m 64m"
TEST_DIRECTORY="/lus/aiholus1/flash/ccarlson"
TEST_FILE="testfile"

set -ex

# Sequential Write
function seq_write {
  TRANSFER_SIZE=$1
  mpirun --machinefile $MACHINE_FILE -np $TOTAL_SLOTS --map-by "slot" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -w -k -o $TEST_DIRECTORY/$TEST_FILE \
    > seq_write_$TRANSFER_SIZE.out
}

# Random Write
function rand_write {
  TRANSFER_SIZE=$1
  mpirun --machinefile $MACHINE_FILE -np $TOTAL_SLOTS --map-by "slot" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -w -z -k -o $TEST_DIRECTORY/$TEST_FILE \
    > rand_write_$TRANSFER_SIZE.out
}

# Sequential Read
function seq_read {
  TRANSFER_SIZE=$1
  mpirun --machinefile $MACHINE_FILE -np $TOTAL_SLOTS --map-by "slot" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -r -k -o $TEST_DIRECTORY/$TEST_FILE \
    > seq_read_$TRANSFER_SIZE.out
}

# Random Read
function rand_read {
  TRANSFER_SIZE=$1
  mpirun --machinefile $MACHINE_FILE -np $TOTAL_SLOTS --map-by "slot" \
    $IOR_BIN -v -F --posix.odirect -C -t $TRANSFER_SIZE -b $BLOCKSIZE_PER_TASK -r -z -k -o $TEST_DIRECTORY/$TEST_FILE \
    > rand_read_$TRANSFER_SIZE.out
}

for TRANSFER_SIZE in $TRANSFER_SIZES; do
  echo -e "\nRunning benchmark with transfer size $TRANSFER_SIZE\n"
  seq_write $TRANSFER_SIZE
  seq_read $TRANSFER_SIZE
  rand_write $TRANSFER_SIZE
  rand_read $TRANSFER_SIZE
done