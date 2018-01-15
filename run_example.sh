#!/bin/bash

# This script does the following
# 1. Clone StackP from our fork (needed due to bad hashbang in LLNL version)
# 2. Clone and build CLMPI from our fork (needed due to borked configure.ac in the LLNL version)
# 3. Clone and build ReMPI from its LLNL repo
# 4. Build a simple MPI program to test recording
# 5. Runs the program with ReMPI in recording mode

# 1. Clone StackP
# No compilation needed since StackP is just a python script that does all the
# object-file manipulation needed to "stack" ReMPI on top of CLMPI 
# The "right" way to do this is usually via PnMPI (https://github.com/LLNL/PnMPI)
# which is a virtualization layer for PMPI. However, ReMPI does not currently
# play nicely with PnMPI and I do not have the time to figure out exactly why. 
# YOU are more than welcome to try to get ReMPI and PnMPI to cooperate...
rm -rf $HOME/StackP_fork
cd $HOME
git clone https://github.com/TauferLab/StackP_fork.git

# 2. Clone and build CLMPI
rm -rf $HOME/CLMPI_fork
git clone https://github.com/TauferLab/CLMPI_fork.git
cd CLMPI_fork
mkdir build
./autogen.sh
./configure --prefix=$HOME/CLMPI_fork/build --with-stack-pmpi=$HOME/StackP_fork MPICC=/usr/bin/mpicc.mpich MPICXX=/usr/bin/mpicxx.mpich
make 
make install
# Modify some environment variables so that ReMPI knows where to find stuff
export CPATH=$CPATH:$HOME/CLMPI_fork/build/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/CLMPI_fork/build/lib

# 3. Clone and build ReMPI 
# - This may take several minutes
# - Parallel make is borked for this
rm -rf $HOME/ReMPI
git clone https://github.com/PRUNERS/ReMPI.git
cd ReMPI
mkdir build
./autogen.sh
./configure --prefix=$HOME/ReMPI/build --enable-cdc --with-clmpi=$HOME/CLMPI_fork/build --with-stack-pmpi=$HOME/StackP_fork MPICC=/usr/bin/mpicc.mpich MPICXX=/usr/bin/mpicxx.mpich
make 
make install

# 4. Build example MPI program
cd $HOME/rempi_example/src
make 

# 5. Run example MPI program with ReMPI in recording mode
sbatch ./sbatch_script 10
