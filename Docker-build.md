# How to build and run the project using Docker

## Building and Running the Docker Containers

### Ensuring `buildx` is enabled

You can check if `buildx` is enabled by running the following command:

```bash
docker buildx version
```

If it is not enabled, you can enable it by running the following command:

```bash
docker plugin install docker/docker-buildx
```

### Building the images

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
