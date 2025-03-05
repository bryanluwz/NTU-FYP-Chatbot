# NTU-FYP-Chatbot

Main folder for NTU FYP Chatbot Project

Please see each submodules README.md for more information, or not up to you...

1. [Node Server](./NTU-FYP-Chatbot-backend/README.md)
2. [Python Server](./NTU-FYP-Chatbot-AI/README.md)
3. [Frontend](./NTU-FYP-Chatbot-frontend/README.md)

There are three ways to run the project:

- [Running the Project with `node` and `python`](#running-the-project-with-node-and-python)
- [Running the Project with `Docker swarm` (with or without GPU)](#running-the-project-with-docker-swarm-with-or-without-gpu)
- [Running the Project with `Docker` and nothing else](#running-the-project-with-docker-and-nothing-else)

## Table of Contents

- [Download and Installation](#download-and-installation)
  - [Clone the repository (including submodules)](#clone-the-repository-including-submodules)
  - [Pull the latest changes](#pull-the-latest-changes)
- [Running the Project with `node` and `python`](#running-the-project-with-node-and-python)
- [Running the Project with Docker swarm (with or without GPU)](#running-the-project-with-docker-swarm-with-or-without-gpu)
  - [For GPU Support](#for-gpu-support)
    - [Docker Desktop (Windows)](#docker-desktop-windows)
    - [WSL2 / Linux](#wsl2--linux)
  - [Building and Running the Docker Containers](#building-and-running-the-docker-containers)
    - [Ensuring buildx is enabled](#ensuring-buildx-is-enabled)
    - [Init swarm](#init-swarm)
    - [Deploy the stack](#deploy-the-stack)
    - [Check the services (optional)](#check-the-services-optional)
    - [See the logs (optional)](#see-the-logs-optional)
    - [Access the services](#access-the-services)
    - [Remove the stack](#remove-the-stack)
- [Running the Project with Docker and nothing else](#running-the-project-with-docker-and-nothing-else)
- [Extra Information](#extra-information)
  - [GPU Support on Docker](#gpu-support-on-docker)
  - [Environment Variables](#environment-variables)
  - [Node Server](#node-server)
  - [Python Server](#python-server)
- [FAQs](#faqs)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Download and Installation

### Clone the repository (including submodules)

```bash
git clone --recurse-submodules <root-repo-url>
```

or if you clone already but forgot to include submodules

```bash
git submodule update --init --recursive
```

### Pull the latest changes

```bash
# For root repository
git pull

# For submodules (checkout main, then pull)
git submodule foreach 'git checkout main'

git submodule foreach 'git pull origin main'
```

## Running the Project with `node` and `python`

_Recommended if you have `node` and `python` installed_

Please refer to the README.md in the respective folders for more information. You should skip the cloning part in each `README.md` instructions as you have already cloned the repository, just ensure that you have the latest changes, and you are running the commands in the right directory. This could be achieved by running `cd <submodule_name>` before running the commands, and you will see the correct path in the terminal.

1. [Node Server](./NTU-FYP-Chatbot-backend/README.md#setup-and-installation)

2. [Python Server](./NTU-FYP-Chatbot-AI/README.md#setup-and-installation)

## Running the Project with `Docker swarm` (with or without GPU)

_Recommended if you don't have `node` and `python`_

**NOTE: You can use `Docker Desktop` or `docker on WSL2` to run the project. Most of the procedures are similar, but there are some differences in the GPU support section. Do not change `docker` styles throuhg setup process**

Similar to using `node` and `python`, you can run the project using Docker. But you would have to create a folder called `secrets` with a bunch `txt` and `json` files,

For more information on the following secrets, please refer to the respective README.md in the submodules. The first one is under the `NTU-FYP-Chatbot-backend` repository, and the second one is under the `NTU-FYP-Chatbot-AI` repository.

1. `jwt_secret.txt` - containing the JWT secret
2. `hf_token.txt` - containing the huggingface token (if running models locally)
3. `together_api_key.txt` - containing the Together API key (if running models with `api-mode`)
4. `azure_api_endpoint.txt` - containing the Azure API endpoint (if running models with `api-mode`)
5. `azure_api_key.txt` - containing the Azure API key (if running models with `api-mode`)
6. `google_cloud_api_key,json` - containing the Google Cloud Service Account JSON credentials thingy (if running models with `api-mode`)

The `secrets` folder should be in the root directory of the project, as follows:

```txt
NTU-FYP-Chatbot
├── NTU-FYP-Chatbot-AI
├── NTU-FYP-Chatbot-backend
├── NTU-FYP-Chatbot-frontend
├── docker-compose.yml
├── secrets
│   ├── jwt_secret.txt
│   ├── ...
│   └── together_api_key.txt
│   ...
└── README.md
```

You do not have to do anything else with the other stuff, just make sure you have the `secrets` folder with the two `.txt` files.

### For GPU Support

Of course you gotta have a GPU to run this, and you need to have the necessary drivers installed. You can check if you have the necessary drivers by running `nvidia-smi` in the terminal. If you see the GPU information, then you are good to go. If not, then you need to install the necessary drivers. How? I don't know, google it.

#### Docker Desktop (Windows)

When you download Docker Desktop, WSL2 is automatically installed (or maybe need specified idk). You can check if you have WSL2 by running `wsl -l -v`. If you see `docker-desktop-data` and `docker-desktop` in the list, then you have WSL2 installed. See [WSL2 / Linux](#wsl2--linux) for further instructions.

If WSL2 is not installed, then you can follow the following instructions:

1. [yes](https://www.google.com/search?q=how+to+install+wsl+with+docker&oq=how+to+install+wsl+with+docker)

#### WSL2 / Linux

_If you are on any Linux distribution, you can follow this guide. Might as well not use the `Docker Desktop` method right?_

Make sure that the docker running is not the Docker Desktop, but the Docker running in WSL2. You can check this by running `docker info` and checking the `Operating System` field. If it is `Docker Desktop`, then you are running the Docker Desktop version, and you should switch to the WSL2 version. You must terminate the `Docker Desktop` app before running the WSL2 terminal.

Alternatively, you can run the following command to switch to the WSL2 version:

```bash
docker context ls
docker context use default
```

Then in the WSL / Linux terminal, you can run the following:

1. Check if you have `docker compose` installed by running `docker-compose --version`. If not, install it by:

   ```bash
   DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
   mkdir -p $DOCKER_CONFIG/cli-plugins
   curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

   chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
   # Test the installation
   docker compose version
   ```

2. Install NVIDIA Container Toolkit (if not installed yet) by:

   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && \
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list && \
   sudo apt update && sudo apt install -y nvidia-container-toolkit
   ```

3. Restart Docker by:

   ```bash
   sudo systemctl restart docker
   ```

   or just restart the ~~computer~~ WSL terminal, by running `wsl --shutdown` in a non-WSL terminal in Windows, make sure right docker context.

4. Check if the NVIDIA Container Toolkit is installed by running

   ```bash
   docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu20.04 nvidia-smi
   ```

5. Test further using the `docker-compose-test.yml` file:

   This might take some time to download

   ```bash
   docker compose -f docker-compose-test.yml up
   ```

   This should print GPU device name.

6. Remove all containers and images by running: (optional, as this will remove everything that was installed)

   ```bash
   docker compose -f docker-compose-test.yml down
   docker system prune -a
   docker rmi $(docker images -q -a)
   ```

7. If everything is working, you need to setup GPU for docker configuration by running:

   ```bash
   sudo ./gpu-setup.sh
   ```

### Building and Running the Docker Containers

Note that you have to use the same docker context as the one you used to test the GPU support. If you are using WSL2, then you should be using the WSL2 context. If you are using Docker Desktop terminal (meaning NO GPU), then you should be using the Docker Desktop context.

#### Ensuring `buildx` is enabled

You can check if `buildx` is enabled by running the following command:

```bash
docker buildx version
```

If it is not enabled, you can enable it by running the following command:

```bash
docker plugin install docker/docker-buildx
```

#### Init swarm

```bash
docker swarm init
```

If there is an error of multiple IP addresses,

For example:

```bash
Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on different interfaces (10.255.255.254 on lo and 172.19.97.46 on eth0) - specify one with --advertise-addr
```

You can specify the IP address to use by running:

```bash
# Get the IP address of eth0 interface
# and run docker swarm init with the extracted IP address
IP=$(ip addr show eth0 | grep -oP 'inet \K[\d.]+')
docker swarm init --advertise-addr $IP
```

or just manually specify the IP address that you want to use,

```bash
# <ip-address> = 172.19.97.46 in above example
docker swarm init --advertise-addr <ip-address>
```

#### Deploy the stack

Build the images by running the following command:

**Note:** This takes forever to build, so be patient and just do some other things while waiting (do not let it go to sleep, cause it won't continue processing when sleeping). REMEMBER TO DELETE `node_modules` and `venv` folders before building the images. (learn it the hard way :/)

**Another Note:** This would also take up a lot of space, so make sure you have enough space to build the images.

**Yet Another Note:** The database or whatever files / folders will be stored in a docker volume, so whatever information you have in those files / folders might also (actually idk, i might fix that alr) be stored in the docker volume. So if you want to keep the data private, DELETE THEM BEFORE BUILDING THE IMAGES.

**Ok Final Note I Promise:** If you do not have `buildx` enabled, then you can build the images separately by just omiting the `buildx` keyword.

**Ok I lied, one more note:** You will be running a few shell files on WSL2/Linux, but I'm not sure whether they're necessary or not, because those are the vestigial remains of my attempts to get the GPU support working. _Wish me good health_

```bash
docker buildx build -t ntu-fyp-chatbot_node-server ./NTU-FYP-Chatbot-backend
docker buildx build -t ntu-fyp-chatbot_python-server ./NTU-FYP-Chatbot-AI
```

Then deploy the stack by running the following command:

_Important_ - If you would like to run the `python` server differently with `debug` mode or `api-mode` mode, you can change the command in the `docker-compose.yml` file. For example, to run the `python` server in `debug` and `api-mode` mode, you can change the command to:
`command: ["python3", "app.py", "--debug", "--api-mode"]`

Do note that the `python` server is run in `debug` mode and `api-mode` mode by default.

With GPU:

```bash
./gpu-pre-deploy.sh # This is to setup the GPU node
docker stack deploy -c docker-compose-gpu.yml ntu-fyp-chatbot
```

Without GPU:

```bash
docker stack deploy -c docker-compose-cpu.yml ntu-fyp-chatbot
```

#### Check the services (optional)

There should be 2 services running: `node-server` and `python-server` (whatever their names are but they should be similar)

```bash
docker stack ps ntu-fyp-chatbot
```

#### See the logs (optional)

```bash
docker service logs ntu-fyp-chatbot_node-server
docker service logs ntu-fyp-chatbot_python-server
```

For real time loggies,

```bash
docker service logs -f ntu-fyp-chatbot_node-server
docker service logs -f ntu-fyp-chatbot_python-server
```

#### Access the services

```bash
IP=$(ip addr show eth0 | grep -oP 'inet \K[\d.]+')
echo "Node Server: https://$IP:3000"
echo "Python Server: https://$IP:3001"
```

The services should **not** be accessible at `https://localhost:3000` (node server) and `https://localhost:3001` (python server which you don't really need to access) respectively.

The ports are set at `3000` and `3001` by default. If you messed with the building process, then you should know where they are.

#### Remove the stack

When you're done, you can remove the stack with the following command:

```bash
docker stack rm ntu-fyp-chatbot
```

## Running the Project with `Docker` and nothing else

Pull images from Docker Hub:

```bash
docker pull bryanluwz/ntu-fyp-chatbot_node-server
docker pull bryanluwz/ntu-fyp-chatbot_python-server_smol
```

Then run the following command:

(-d) for detached mode

```bash
docker compose -f docker-compose-node-deployment.yml -f docker-compose-python-deployment-smol.yml up -d
```

Then you can access the services at `https://localhost:3000` or whereever is is running respectively.

To stop the services, you can run:

```bash
docker compose -f docker-compose-node-deployment.yml -f docker-compose-python-deployment-smol.yml down
```

## Extra Information

### GPU Support on Docker

- If not working then idk man, it took me way too long on this already. I'm not gonna help you with this. bye .\_.

### Environment Variables

- The environment variables are set in the `docker-compose.yml` file. You can change them there if you need to. But I won't guarantee that it will work.

- These includes the ports, volumes, and other stuff that you might want to change.

### Node Server

- The node server database is stored in a volume at `/app/database`, which includes `database.db` and other related folders. It is initialised on the first run of the node server. All subsequent runs will use the same database _I hope_.

- The frontend build is stored in a volume at `/app/fe-dist`, which includes the compiled frontend code. So make sure that the frontend built code folder exists before building the docker image.

### Python Server

- The python server uses a `requirements.txt` file in its repository to install the necessary packages. If you need to add more packages, please add them to the `requirements.txt` file.

- The python server uses a `model` volume in its repository to store the model files, which includes LLMs, BLIPs, embeddings, etc. This folder is initialised on the first run of the python server. All subsequent runs will use the same model files _I hope_. Similarly, a `documents` volume and `temp_storage` folder (_not volume ah_) is used to store the documents and temporary files respectively.

## FAQs

1. Why so slow?

   - Because I'm slow. 🐢

2. Why only slow the first time running?

   - Bro I have no idea you gotta ask the AI overlords.

3. Docker not found, Daemon not running, etc.

   - Did you run Docker Desktop before shutting it down? No? Good, then you're good to go.
     Yes? Then run `wsl --shutdown` in a non-WSL terminal in Windows.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

I would like to thank the following:

1. [ME](https://github.com/bryanluwz) for building this awesome chatbot, alone...
2. [ChatGPT](https://chat.open.ai/) for providing me sanity (and assistance) during this project.
3. [Github Copilot](https://copilot.github.com/) for sort of helping me during this project.
4. [Sheer Willpower](https://www.youtube.com/watch?v=ZXsQAXx_ao0) for keeping me alive during this project, knowing that what I'm doing is probably not worth it.
5. The Universe for giving me the opportunity to do this project, which I probably won't do again, but hey, at least I did it once, right? (not like it's what i wanted in the first place, and might even be irrelevant in the future, but hey, at least I did something right? for the sake of whomever it may concern, if it even concerns anyone at all, which it probably doesn't, but hey, at least I tried)

```

```
