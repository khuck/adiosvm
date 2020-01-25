#!/bin/bash

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