# NTU-FYP-Chatbot

Main folder for NTU FYP Chatbot Project

Please see each submodules README.md for more information, or not up to you...

1. [Node Server](./NTU-FYP-Chatbot-backend/README.md)
2. [Python Server](./NTU-FYP-Chatbot-AI/README.md)
3. [Frontend](./NTU-FYP-Chatbot-frontend/README.md)

There are three ways to run the project:

- [Running the Project with `node` and `python`](#running-the-project-with-node-and-python)
- [Running the Project with Docker swarm (with or without GPU)](#running-with-docker-swarm-with-or-without-gpu)
- [Running the Project with Docker and nothing else](#running-the-project-with-docker-and-nothing-else)

If you don't want to run, then check out the deployed service I did for my FYP, though with some restricted features: [Here](http://ec2-54-169-177-146.ap-southeast-1.compute.amazonaws.com/)

## Table of Contents

- [Download and Installation](#download-and-installation)
  - [Clone the repository (including submodules)](#clone-the-repository-including-submodules)
  - [Pull the latest changes](#pull-the-latest-changes)
- [Running the Project with `node` and `python`](#running-the-project-with-node-and-python)
- [Running with `Docker`](#running-with-docker)
  - [Docker Images from Docker Hub](#docker-images-from-docker-hub)
  - [Building your own images](#building-your-own-images)
  - [Prerequisites](#prerequisites)
  - [Running with Docker swarm (with or without GPU)](#running-with-docker-swarm-with-or-without-gpu)
    - [Initialise swarm](#initialise-swarm)
    - [Deploying stack](#deploying-stack)
    - [See the logs (optional)](#see-the-logs-optional)
    - [Access the services](#access-the-services)
    - [Remove the stack](#remove-the-stack)
    - [Leave the swarm (optional, but recommended)](#leave-the-swarm-optional-but-recommended)
  - [Running the Project with `Docker` and nothing else](#running-the-project-with-docker-and-nothing-else)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Download and Installation

### Clone the repository (including submodules)

```bash
git clone --recurse-submodules https://github.com/bryanluwz/NTU-FYP-Chatbot
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

## Running with `Docker`

_Recommended if you don't have `node` and `python`_

**NOTE: You can use `Docker Desktop` or `docker on WSL2` to run the project. Most of the procedures are similar, but there are some differences in the GPU support section. Do not change `docker` styles throuhg setup process**

Similar to using `node` and `python`, you can run the project using Docker. But you would have to create a folder called `secrets` with a bunch `txt` and `json` files.

1. `jwt_secret.txt` - containing the JWT secret
2. `rag_tokens.txt` - containing the huggingface token (for LLM local) + Together API key (for LLM API)
3. `azure_api.txt` - containing the Azure Vison API endpoint + key + Azure OpenAI API endpoint + key
4. `google_cloud_api_key.json` - containing the Google Cloud Service Account JSON credentials thingy (if running models with `api-mode`)

For files that contain more than one secret, you can separate them with a new line. For example, the `rag_tokens.txt` file should look like this:

```txt
huggingface_token
together_api_key
```

The `secrets` folder should be in the root directory of the project, as follows:

```txt
NTU-FYP-Chatbot
├── NTU-FYP-Chatbot-AI
├── NTU-FYP-Chatbot-backend
├── NTU-FYP-Chatbot-frontend
├── secrets
│   ├── jwt_secret.txt
│   ├── ...
│   └── rag_tokens.txt
│   ...
└── README.md
```

### Docker Images from Docker Hub

There are four images available on Docker Hub:

1. [Node server](https://hub.docker.com/repository/docker/bryanluwz/ntu-fyp-chatbot_node-server), for the backend server.
2. [Python server (smol)](https://hub.docker.com/repository/docker/bryanluwz/ntu-fyp-chatbot_python-server_smol), this uses API services instead of running models, such as LLMs, BLIPs, embeddings, etc., locally, for potato computers.
3. [Python server (API services)](https://hub.docker.com/repository/docker/bryanluwz/ntu-fyp-chatbot_python-server), this uses the API services instead of running models, such as LLMs and BLIPs, locally.
4. [Python server (local models)](https://hub.docker.com/repository/docker/bryanluwz/ntu-fyp-chatbot_python-server_local), this uses the local models, such as LLMs and BLIPs, instead of the API services.

Before running any `docker compose` commands, make sure that the `docker-compose-whatever.yml` files are using the right images for your use case.

### Building your own images

If you don't want to use the images that I have built, and want to build your own images, see [Docker-build.md](./Docker-build.md) for more information.

### Prerequisites

See [Docker-prerequisites.md](./Docker-prerequisites.md) for more information.

### Running with Docker swarm (with or without GPU)

#### Initialise swarm

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

#### Deploying stack

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

The services should be accessible at whatever your IP address is + the ports. For example, if your IP address is `1.2.3.4`, then you can access the services at `http://1.2.3.4:3000` and `http://1.2.3.4:3001`.

The ports are set at `3000` and `3001` by default. If you messed with the port number during the building process, then you should know where they are.

#### Remove the stack

When you're done, you can remove the stack with the following command:

```bash
docker stack rm ntu-fyp-chatbot
```

#### Leave the swarm (optional, but recommended)

When you're done with everything, you can leave the swarm by running the following command:

```bash
docker swarm leave --force
```

If you don't leave the swarm, then you do not have to init the swarm again when you want to deploy the stack again. But if you leave the swarm, then you have to init the swarm again before deploying the stack.

### Running the Project with `Docker` and nothing else

Again, change the image name to whichever image you want to use in the following `docker-compose` commands. I'm using the `smol` version of the python server for this example.

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

### Node Server

- The node server database is stored in a volume at `/app/database`, which includes `database.db` and other related folders. It is initialised on the first run of the node server. All subsequent runs will use the same database _I hope_.

- The frontend build is stored in a volume at `/app/fe-dist`, which includes the compiled frontend code. So make sure that the frontend built code folder exists before building the docker image.

### Python Server

- The python server uses a `requirements.txt` file in its repository to install the necessary packages. If you need to add more packages, please add them to the `requirements.txt` file.

- The python server uses a `model` volume in its repository to store the model files, which includes LLMs, BLIPs, embeddings, etc. This folder is initialised on the first run of the python server. All subsequent runs will use the same model files _I hope_. Similarly, a `documents` volume and `temp_storage` folder (_not volume ah_) is used to store the documents and temporary files respectively.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

I would like to thank the following:

1. [ME](https://github.com/bryanluwz) for building this awesome chatbot, alone...
2. [ChatGPT](https://chat.open.ai/) for providing me sanity (and assistance) during this project.
3. [Github Copilot](https://copilot.github.com/) for sort of helping me during this project.
4. [Sheer Willpower](https://www.youtube.com/watch?v=ZXsQAXx_ao0) for keeping me alive during this project, knowing that what I'm doing is probably not worth it.
5. The Universe for giving me the opportunity to do this project, which I probably won't do again, but hey, at least I did it once, right? (not like it's what i wanted in the first place, and might even be irrelevant in the future, but hey, at least I did something right? for the sake of whomever it may concern, if it even concerns anyone at all, which it probably doesn't, but hey, at least I tried)
