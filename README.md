# NTU-FYP-Chatbot

Main folder for NTU FYP Chatbot Project

Please see each submodules README.md for more information.

1. [Node Server](./NTU-FYP-Chatbot-backend/README.md)
2. [Python Server](./NTU-FYP-Chatbot-AI/README.md)
3. [Frontend](./NTU-FYP-Chatbot-frontend/README.md)

## Setup and Installation

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

Please refer to the README.md in the respective folders for more information.

[Node Server](./NTU-FYP-Chatbot-backend/README.md#setup-and-installation)
[Python Server](./NTU-FYP-Chatbot-AI/README.md#setup-and-installation)

## Running the Project with Docker

_Recommended if you don't have `node` and `python`_

Similar to using `node` and `python`, you can run the project using Docker. But you would have to create a folder called `secrets` with two `txt` files,

1. `jwt_secret.txt` - containing the JWT secret
2. `hf_token.txt` - containing the huggingface token

The `secrets` folder should be in the root directory of the project, as follows:

```txt
NTU-FYP-Chatbot
├── NTU-FYP-Chatbot-AI
├── NTU-FYP-Chatbot-backend
├── NTU-FYP-Chatbot-frontend
├── docker-compose.yml
├── secrets
│   ├── jwt_secret.txt
│   └── hf_token.txt
│   ...
└── README.md
```

### Init swarm

```bash
docker swarm init
```

### Deploy the stack

```bash
# Build the images (will take forever so prepare some popcorn)
docker build -t ntu-fyp-chatbot_node-server ./NTU-FYP-Chatbot-backend
docker build -t ntu-fyp-chatbot_python-server ./NTU-FYP-Chatbot-AI

docker stack deploy -c docker-compose.yml ntu-fyp-chatbot
```

### Check the services (optional)

There should be 2 services running: `node-server` and `python-server` (whatever their names are but they should be similar)

```bash
docker stack ps ntu-fyp-chatbot
```

### See the logs (optional)

```bash
docker service logs ntu-fyp-chatbot_node-server
docker service logs ntu-fyp-chatbot_python-server
```

### Access the services

The services should be accessible at `https://localhost:3000` (node server) and `https://localhost:3001` (python server which you don't really need to access) respectively.

The ports are set at `3000` and `3001` by default. If you messed with the building process, then you should know where they are.

### Remove the stack

When you're done, you can remove the stack with the following command:

```bash
docker stack rm ntu-fyp-chatbot
```

### Extra Information

#### Environment Variables

- The environment variables are set in the `docker-compose.yml` file. You can change them there if you need to. But I won't guarantee that it will work.

#### Node Server

- The node server database is stored in a volume at `/app/database`, which includes `database.db` and other related folders. It is initialised on the first run of the node server. All subsequent runs will use the same database _I hope_.

- The frontend build is stored in a volume at `/app/fe-dist`, which includes the compiled frontend code. So make sure that the frontend built code folder exists before building the docker image.

#### Python Server

- The python server uses a `requirements.txt` file in its repository to install the necessary packages. If you need to add more packages, please add them to the `requirements.txt` file.

- The python server uses a `model` volume in its repository to store the model files, which includes LLMs, BLIPs, embeddings, etc. This folder is initialised on the first run of the python server. All subsequent runs will use the same model files _I hope_. Similarly, a `documents` volume and `temp_storage` folder (_not volume ah_) is used to store the documents and temporary files respectively.

## FAQs

1. Why so slow?

   - Because I'm slow. 🐢

2. Why only slow the first time running?

   - Because I'm slow to initialise, and I only initialise each sub components when needed ok? 🐢

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

I would like to thank the following:

1. [ME](https://github.com/bryanluwz) for building this awesome chatbot, alone...
2. [ChatGPT](https://chat.open.ai/) for providing me sanity (and assistance) during this project.
3. [Github Copilot](https://copilot.github.com/) for sort of helping me during this project.
4. [Sheer Willpower](https://www.youtube.com/watch?v=ZXsQAXx_ao0) for keeping me alive during this project, knowing that what I'm doing is probably not worth it.
5. The Universe for giving me the opportunity to do this project, which I probably won't do again, but hey, at least I did it once, right? (not like it's what i wanted in the first place, and might even be irrelevant in the future, but hey, at least I did something right? for the sake of whomever it may concern, if it even concerns anyone at all, which it probably doesn't, but hey, at least I tried)
6. Definitely not my supervising professor, for forgetting that I exist, not providing assistance, providing terrible advice, and not even knowing what I'm doing. But, at least this will get me out of this hellscape faster right?
