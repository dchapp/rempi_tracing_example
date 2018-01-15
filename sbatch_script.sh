#!/bin/sh

#SBATCH -N 1
#SBATCH -ppdebug
#SBATCH -o rempi-example-%j.out
#SBATCH -e rempi-example-%j.err

iters=$1

LD_PRELOAD_PATH=$HOME/ReMPI/build/lib/librempix.so
REMPI_DIR=$HOME/rempi_example/src/rempi_records
REMPI_MODE=0
REMPI_ENCODE=4
REMPI_GZIP=1

export LD_PRELOAD_PATH
export REMPI_DIR
export REMPI_MODE
export REMPI_ENCODE
export REMPI_GZIP

date
REMPI_DIR=${REMPI_DIR} REMPI_MODE=${REMPI_MODE} REMPI_ENCODE=${REMPI_ENCODE} REMPI_GZIP=${REMPI_GZIP} LD_PRELOAD=${LD_PRELOAD_PATH} srun -N1 -n4 --mpi=pmi2 "${HOME}/rempi_example/src/pathological.exe" ${iters}
date
