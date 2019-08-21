#!/bin/bash

# Run without TAU
rm -rf *.bp *.bp.dir *.bp.sst profile.* dump.*
mpirun -np 8 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU
rm -rf *.bp *.bp.dir *.bp.sst
mpirun -np 8 tau_exec -T mpi,pthread,adios2 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU and ADIOS2 output of profile data
rm -rf *.bp *.bp.dir *.bp.sst profile.* dump.*
mpirun -np 8 tau_exec -T mpi,pthread,adios2 -adios2 ./simulation/Brusselator simulation.data 16 16 16 1000 100

# Run with TAU and ADIOS2 output of profile data, and get periodic OS/HW metrics 
# see ./tau_components.json to control frequency and detail
rm -rf *.bp *.bp.dir *.bp.sst profile.* dump.*
mpirun -np 8 tau_exec -T mpi,pthread,adios2 -adios2 -papi_components ./simulation/Brusselator simulation.data 16 16 16 1000 100

# To run with analysis reader, enable the bottom two lines

#sleep 2
#mpirun -np 8 ./analysis/norm_calc2 simulation.data normal.data 0
