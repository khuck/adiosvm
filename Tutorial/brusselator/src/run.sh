#!/bin/bash

rm -rf *.bp *.bp.dir *.bp.sst profile.* dump.*

# Run without TAU
#mpirun -np 8 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU
#mpirun -np 8 tau_exec -T papi,mpi,pthread,adios2 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU and ADIOS2 output of profile data
#mpirun -np 8 tau_exec -T papi,mpi,pthread,adios2 -adios2 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU and ADIOS2 output of profile data, and get periodic OS/HW metrics
mpirun -np 8 tau_exec -T papi,mpi,pthread,adios2 -adios2 -papi_components ./simulation/Brusselator simulation.data 16 16 16 1000 100

# To run with analysis reader, enable the bottom two lines

#sleep 2
#mpirun -np 8 ./analysis/norm_calc2 simulation.data normal.data 0