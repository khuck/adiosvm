#!/bin/bash

module load cmake/3.15.4
module list

rm -rf build
mkdir build
cd build

cmake .. \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=${CC} \
-DCMAKE_CXX_COMPILER=${CXX} \
-DCMAKE_PREFIX_PATH=${ADIOS_DIR}/lib64/cmake;../../perfstubs/install/lib/cmake

make  VERBOSE=1