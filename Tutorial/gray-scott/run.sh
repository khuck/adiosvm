#!/bin/bash

# Clean up
rm profile.* traces.* tauprofile-gray-scott.bp

module list

sockets=`lscpu | grep Socket | awk '{print $NF}'`
cores=`lscpu | grep Core | awk '{print $NF}'`
numranks=`echo "${sockets} * ${cores}" | bc`

mpirun -np ${numranks} \
--oversubscribe \
-mca btl_openib_warn_no_device_params_found 0 \
-mca btl_openib_allow_ib true \
tau_exec -T mpi,papi,pthread,adios2 \
-adios2 \
-papi_components \
build/gray-scott simulation/settings-files.json

