#!/bin/bash

# Clean up
rm -rf profile.* traces.* *.bp

module list

sockets=`lscpu | grep Socket | awk '{print $NF}'`
cores=`lscpu | grep Core | awk '{print $NF}'`
threads=`lscpu | grep CPU | head -1 | awk '{print $NF}'`

#numranks=1
#numranks=${sockets}
numranks=`echo "${sockets} * ${cores}" | bc`
#numranks=`echo "${threads} / 2" | bc`

run_sim() {
set -x
mpirun -np ${numranks} \
-mca btl_openib_warn_no_device_params_found 0 \
tau_exec -T pgi \
-papi_components \
-adios2 \
build/gray-scott simulation/settings-files.json
}
#tau_exec -v -T pgi \
#-papi_components \
#-adios2 \
#valgrind --trace-children=yes --log-file=vglog.%p \

# Run the viz

run_viz() {
mpirun -np 1 \
-mca btl_openib_warn_no_device_params_found 0 \
-mca btl_openib_allow_ib true \
./monitoring.py -o utilization -i tauprofile-gray-scott.bp -dsec 0
}

run_sim
