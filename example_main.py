import argparse
import os
import sys
import socket

import torch
import torch.distributed as dist


def train(global_rank, world_size, hostname, gpus_per_node):
    # this is where the training code will go. This can be a different file
    local_rank = glgobal_rank % gpus_per_node
    print(f'{hostname = }, {global_rank = },  {local_rank = }, {world_size = }')

    # actual training code goes here
    # ...

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--gpus-per-node', type=int, default=4)
    args = parse.parse_args()
    
    if not 'SLURM_PROCID' in os.environ:
        print('SLURM_PROCID not found. Exiting')
        sys.exit(1)

    if not 'SLURM_NTASKS' in os.environ:
        print('SLURM_NTASKS not found. Exiting')
        sys.exit(1)
        
    global_rank = int(os.getenv('SLURM_PROCID'))
    world_size = int(os.getenv('SLURM_NTASKS'))

    hostname = socket.gethostname()

    dist.init_process_group(backend='nccl', rank=global_rank, world_size=world_size)
    
    # now run your distributed training code
    train(global_rank, world_size, hostname, args.gpus_per_node)
