#!/usr/bin/env python3
import pandas as pd
from mpi4py import MPI
import numpy as np
import adios2
#import os
#import glob
#from multiprocessing import Pool
#import time
import argparse
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import operator
from operator import add
from matplotlib.font_manager import FontProperties

# CPU: Pretty names for graph
cpu_components_for_graph = ['Guest','I/O Wait', 'IRQ', 'Idle', 'Nice', 'Steal', 'System', 'User', 'soft IRQ']
# Actual ADIOS2 variable names
cpu_components = ['cpu: Guest % / Mean','cpu: I/O Wait % / Mean', 'cpu: IRQ % / Mean', 'cpu: Idle % / Mean', 'cpu: Nice % / Mean', 'cpu: Steal % / Mean', 'cpu: System % / Mean', 'cpu: User % / Mean', 'cpu: soft IRQ % / Mean']

# Memory: Pretty names for graph
mem_components_for_graph = ['Memory Footprint (VmRSS) (KB)','Peak Memory Usage Resident Set Size (VmHWM) (KB)','program size (kB)','resident set size (kB)']
# Actual ADIOS2 variable names
mem_components = ['Memory Footprint (VmRSS) (KB) / Mean','Peak Memory Usage Resident Set Size (VmHWM) (KB) / Mean','program size (kB) / Mean','resident set size (kB) / Mean']

def SetupArgs():
    parser = argparse.ArgumentParser()
    parser.add_argument("--instream", "-i", help="Name of the input stream", required=True)
    parser.add_argument("--outfile", "-o", help="Name of the output file", default="screen")
    parser.add_argument("--nompi", "-nompi", help="ADIOS was installed without MPI", action="store_true")
    parser.add_argument("--displaysec", "-dsec", help="Float representing gap between plot window refresh", default=0.2)
    args = parser.parse_args()

    args.displaysec = float(args.displaysec)
    args.nx = 1
    args.ny = 1
    args.nz = 1

    return args

def get_num_hosts(attr_info):
    names = {}
    # Iterate over the metadata, and get our hostnames.
    # Build a dictionary of unique values, if the value is
    # already there overwrite it.
    for key in attr_info:
        if "Hostname" in key:
            names[(attr_info[key]['Value'])] = 1
    return len(names)

# Build a dataframe that has per-node data for this timestep of the output data

def build_per_host_dataframe(fr_step, step, num_hosts, variables, columns):
    # Read the number of ranks - check for the new method first
    num_ranks = 1
    if len(fr_step.read('num_ranks')) == 0:
        num_ranks = len(fr_step.read('num_threads'))
    else:
        num_ranks = fr_step.read('num_ranks')[0]

    # Find out how many ranks per node we have
    ranks_per_node = num_ranks / num_hosts
    rows = []
    # For each variable, get each MPI rank's data, some will be bogus (they didn't write it)
    for name in variables:
        rows.append(fr_step.read(name))
    # Now, transpose the matrix so that the rows are each rank, and the variables are columns
    df = pd.DataFrame(rows).transpose()
    # Add a name for each column
    df.columns = columns
    # Add the MPI rank column (each row is unique)
    df['mpi_rank'] = range(0, len(df))
    # Add the step column, all with the same value
    df['step']=step
    # Filter out the rows that don't have valid data (keep only the lowest rank on each host)
    # This will filter out the bogus data
    df_trimmed = df[df['mpi_rank']%ranks_per_node == 0]
    #print(df_trimmed)
    df_trimmed[columns].plot(kind='bar', stacked=True)
    imgfile = "cpu_utilization"+"_"+"{0:0>5}".format(step)+".svg"
    plt.savefig(imgfile)

# Build a dataframe that has per-rank data for this timestep of the output data

def build_per_rank_dataframe(fr_step, step, variables, columns):
    rows = []
    # For each variable, get each MPI rank's data
    for name in variables:
        rows.append(fr_step.read(name))
    # Now, transpose the matrix so that the rows are each rank, and the variables are columns
    df = pd.DataFrame(rows).transpose()
    # Add a name for each column
    df.columns = columns
    # Add the MPI rank column (each row is unique)
    df['mpi_rank'] = range(0, len(df))
    # Add the step column, all with the same value
    df['step']=step
    #print(df)
    df[columns].plot(logy=True)
    imgfile = "mem_utilization"+"_"+"{0:0>5}".format(step)+".svg"
    plt.savefig(imgfile)

# Process the ADIOS2 file

def process_file(args):
    filename = args.instream
    print ("Opening:", filename)
    if not args.nompi:
        fr = adios2.open(filename, "r", MPI.COMM_SELF, "adios2.xml", "TAUProfileOutput")
    else:
        fr = adios2.open(filename, "r", "adios2.xml", "TAUProfileOutput")
    # Get the attributes (simple name/value pairs)
    attr_info = fr.available_attributes()
    # Get the unique host names from the attributes
    num_hosts = get_num_hosts(attr_info)
    cur_step = 0
    # Iterate over the steps
    for fr_step in fr:
        # track current step
        cur_step = fr_step.current_step()
        print(filename, "Step = ", cur_step)
        # Get the cpu utilization data
        build_per_host_dataframe(fr_step, cur_step, num_hosts, cpu_components, cpu_components_for_graph)
        # Get the memory utilization data
        build_per_rank_dataframe(fr_step, cur_step, mem_components, mem_components_for_graph)


if __name__ == '__main__':
    args = SetupArgs()
    #print(args)
    process_file(args)

