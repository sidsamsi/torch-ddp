#!/bin/bash
#SBATCH -t 0:05:00
#SBATCH -N 2
#SBATCH --gpus-per-node=4
#SBATCH --output=%j.out

# Debug prints
echo "SLURM_JOB_ID: $SLURM_JOB_ID"
echo "SLURM_NODELIST: $SLURM_JOB_NODELIST"
echo "SLURM_NODEID: $SLURM_NODEID"

# Function to find an available port
get_free_port() {
    python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()'
}

# Get the master node's address
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)

# Get a free port and export it
export MASTER_PORT=$(get_free_port)

# Print for debugging
echo "Using MASTER_ADDR: $MASTER_ADDR"
echo "Using MASTER_PORT: $MASTER_PORT"

# Make sure NCCL can work across nodes
export NCCL_DEBUG=INFO  # Add this for NCCL debugging
export NCCL_IB_DISABLE=0
export NCCL_NET_GDR_LEVEL=2

# Change --gpus-per-node to the actual value specified in the #SBATCH command above
srun example_main.py --gpus-per-node=4

