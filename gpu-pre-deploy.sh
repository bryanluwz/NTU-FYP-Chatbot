#!/bin/bash

# Check if the node has NVIDIA GPU by running nvidia-smi
if nvidia-smi > /dev/null 2>&1; then
    echo "GPU detected. Labeling node with 'gpu=true'."
    # Label the node as having GPU
    docker node update --label-add gpu=true $(docker info --format '{{.Swarm.NodeID}}')
else
    echo "No GPU detected on this node."
fi
