#!/bin/bash

module load cuda/9.2 cmake/3.15.4 gcc/7.3 openmpi/4.0.1-gcc7.3 
module list

rm -rf build
mkdir build
cd build

cmake .. \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=`which gcc` \
-DCMAKE_CXX_COMPILER=`which g++` \
-DCMAKE_PREFIX_PATH=$HOME/src/ADIOS2/install_mpi/lib64/cmake;../perfstubs/install/lib/cmake

make  VERBOSE=1