#!/bin/bash

CUFILE_ENV_PATH_JSON=/root/gdsio_cufile.json
GDS_TOOLS=/usr/local/cuda-12.3/gds/tools
OUTPUT_DIR=/mnt/cstor1/ccarlson/flash
WORKER_THREADS=64
GPU_DEVICE_INDEX=0
FILE_SIZE=1G
IO_SIZE=2M
READ=0
WRITE=1
RAND_READ=2
RAND_WRITE=3
GDS=0

/usr/local/cuda-12.3/gds/tools/gdsio -I 1 -x 0 -i 2M -s 1G -d 0 -w 64 -D /mnt/cstor1/ccarlson/flash