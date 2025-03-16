# I want to deploy using `git` and `docker`

I assume you have both `git` and `docker` already

1. Pull this repo first and switch to the NTU-FYP-Chatbot directory

   ```bash
   git clone --recurse-submodules https://github.com/bryanluwz/NTU-FYP-Chatbot
   cd NTU-FYP-Chatbot
   ```

2. Download `docker compose` if not available

   ```bash
   DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
   mkdir -p $DOCKER_CONFIG/cli-plugins
   curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
   chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
   # Test the installation
   docker compose version
   ```

3. Pull docker images from dockerhub

   ```bash
   docker pull bryanluwz/ntu-fyp-chatbot_node-server
   docker pull bryanluwz/ntu-fyp-chatbot_python-server_smol
   ```

4. Create API keys for usage

   ```bash
   mkdir secrets
   touch secrets/jwt_secret.txt
   touch secrets/rag_tokens.txt
   touch secrets/azure_api.txt
   touch secrets/google_cloud_api_key.json
   ```

   1. `jwt_secret.txt` - containing the JWT secret
   2. `rag_tokens.txt` - containing the huggingface token (for LLM local) + Together API key (for LLM API)
   3. `azure_api.txt` - containing the Azure Vison API endpoint + key + Azure OpenAI API endpoint + key
   4. `google_cloud_api_key.json` - containing the Google Cloud Service Account JSON credentials thingy (a JSON object)

   For files that contain more than one secret, you can separate them with a new line. For example, the `rag_tokens.txt` file should look like this:

   ```txt
   <huggingface_token>
   <together_api_key>
   ```

   Leave blank if not needed.

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

5. Run the docker containers

   ```bash
   docker compose -f docker-compose-node-deployment.yml -f docker-compose-python-deployment-smol.yml up -d
   ```
