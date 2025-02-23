#!/bin/bash

# Step 1: Check for NVIDIA GPUs
echo "Checking for NVIDIA GPUs..."

GPU_UUID=$(nvidia-smi --query-gpu=gpu_uuid --format=csv,noheader)

if [ -z "$GPU_UUID" ]; then
    echo "No GPU found. Please make sure you have NVIDIA GPUs installed and drivers are properly configured."
    exit 1
fi

# Extract GPU UUID (first GPU UUID if multiple GPUs exist)
GPU_UUID=${GPU_UUID%%,*}  # Use first UUID if there's a comma (multiple GPUs)

echo "Found GPU UUID: $GPU_UUID"

# Step 2: Update /etc/nvidia-container-runtime/config.toml
echo "Updating /etc/nvidia-container-runtime/config.toml..."

# Ensure the line 'swarm-resource = "DOCKER_RESOURCE_GPU"' exists (uncomment if necessary)
sudo sed -i '/^#swarm-resource/s/^#//' /etc/nvidia-container-runtime/config.toml
sudo sed -i 's/^#swarm-resource = "DOCKER_RESOURCE_GPU"/swarm-resource = "DOCKER_RESOURCE_GPU"/' /etc/nvidia-container-runtime/config.toml

echo "swarm-resource = 'DOCKER_RESOURCE_GPU' enabled in config.toml"

# Step 3: Update /etc/docker/daemon.json to set NVIDIA GPU as default runtime
echo "Updating /etc/docker/daemon.json..."

# Add default runtime and generic resources for GPU
sudo bash -c "cat > /etc/docker/daemon.json <<EOF
{
  \"runtimes\": {
    \"nvidia\": {
      \"path\": \"/usr/bin/nvidia-container-runtime\",
      \"runtimeArgs\": []
    }
  },
  \"default-runtime\": \"nvidia\",
  \"node-generic-resources\": [
    \"NVIDIA-GPU=$GPU_UUID\"
  ]
}
EOF"

echo "Daemon configuration updated with NVIDIA runtime and GPU UUID."

# Step 4: Restart Docker
echo "Restarting Docker service..."

sudo systemctl restart docker

# # Step 5: Confirm the setup
# echo "Verifying setup..."

# # Check Docker runtime configuration
# docker info | grep -i "Runtimes"

# # Run nvidia-smi inside a test container
# docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# echo "GPU setup complete. Docker is now configured to use the GPU."
