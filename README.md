# NTU-FYP-Chatbot

Main folder for NTU FYP Chatbot Project

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
