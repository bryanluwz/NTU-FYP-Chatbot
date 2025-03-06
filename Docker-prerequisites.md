# Docker Prerequisites

## `docker compose`

In the WSL / Linux terminal, you can run the following:

1. Check if you have `docker compose` installed by running `docker-compose --version`. If not, install it by:

   ```bash
   DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
   mkdir -p $DOCKER_CONFIG/cli-plugins
   curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

   chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
   # Test the installation
   docker compose version
   ```

## Docker with GPU Support

Of course you gotta have a GPU to run this, and you need to have the necessary drivers installed. You can check if you have the necessary drivers by running `nvidia-smi` in the terminal. If you see the GPU information, then you are good to go. If not, then you need to install the necessary drivers. How? I don't know, google it.

1. Install NVIDIA Container Toolkit (if not installed yet) by:

   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && \
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list && \
   sudo apt update && sudo apt install -y nvidia-container-toolkit
   ```

2. Restart Docker by:

   ```bash
   sudo systemctl restart docker
   ```

   or just restart the ~~computer~~ WSL terminal, by running `wsl --shutdown` in a non-WSL terminal in Windows, make sure right docker context.

3. Check if the NVIDIA Container Toolkit is installed by running

   ```bash
   docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu20.04 nvidia-smi
   ```

4. Test further using the `docker-compose-test.yml` file:

   This might take some time to download

   ```bash
   docker compose -f docker-compose-test.yml up
   ```

   This should print GPU device name.

5. Remove all containers and images by running: (optional, as this will remove everything that was installed)

   ```bash
   docker compose -f docker-compose-test.yml down
   docker system prune -a
   docker rmi $(docker images -q -a)
   ```

6. If everything is working, you need to setup GPU for docker configuration by running:

   ```bash
   sudo ./gpu-setup.sh
   ```

### Docker Desktop (Windows)

When you download Docker Desktop, WSL2 is automatically installed (or maybe need specified idk). You can check if you have WSL2 by running `wsl -l -v`. If you see `docker-desktop-data` and `docker-desktop` in the list, then you have WSL2 installed. See [WSL2 / Linux](#wsl2--linux) for further instructions.

If WSL2 is not installed, then you can follow the following instructions:

1. [yes](https://www.google.com/search?q=how+to+install+wsl+with+docker&oq=how+to+install+wsl+with+docker)

### WSL2 / Linux

_If you are on any Linux distribution, you can follow this guide. Might as well not use the `Docker Desktop` method right?_

Make sure that the docker running is not the Docker Desktop, but the Docker running in WSL2. You can check this by running `docker info` and checking the `Operating System` field. If it is `Docker Desktop`, then you are running the Docker Desktop version, and you should switch to the WSL2 version. You must terminate the `Docker Desktop` app before running the WSL2 terminal.

Alternatively, you can run the following command to switch to the WSL2 version:

```bash
docker context ls
docker context use default
```
