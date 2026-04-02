# LlamaCPP Docker & API Setup

This repository provides a **full LlamaCPP Docker environment** with a Python API interface. It allows you to run Llama models locally via Docker and interact with them using Python scripts.

---

## 📁 Repository Contents

| File               | Description                                                                                    |
| ------------------ | ---------------------------------------------------------------------------------------------- |
| Dockerfile         | Builds the LlamaCPP API Docker image.                                                          |
| requirements.txt   | Python dependencies for API usage.                                                             |
| setup_llamacpp.sh  | Bash script to install Docker, download models, build the Docker image, and run the container. |
| llama_api.py       | Python wrapper for interacting with the LlamaCPP API.                                          |
| example_request.py | Example Python script demonstrating how to send prompts to the API.                            |

---

## 🚀 Setup Instructions

### 1. Make the Script Executable

chmod +x setup_llamacpp.sh

### 2. Run the Setup Script

./setup_llamacpp.sh

The script performs the following:

1. Checks if git is installed, and installs it if missing
2. Removes old Docker and Podman remnants
3. Installs Docker official packages and prerequisites
4. Clones or updates the llamacpp-docker repository
5. Ensures the models folder exists
6. Downloads the specified Llama model if not already present
7. Builds the Docker image named llamacpp-api
8. Stops and removes any existing container named llamacpp-api
9. Runs a new container named llamacpp-api on port 8000

After the script completes, the container will be running and ready to accept requests.

---

## ✅ Test the API

curl "http://localhost:8000/generate?prompt=Hello+world"

You should receive a JSON response from the LlamaCPP model.

---

## 🐍 Python API Usage

### 1. Install Dependencies

pip install -r requirements.txt

### 2. Example Usage

from llama_api import LlamaAPI

api = LlamaAPI("http://localhost:8000")
response = api.generate("Hello world")
print(response)

### 3. Run the Example Script

python example_request.py

---

## 🐳 Docker Notes

* Image name: llamacpp-api
* Container name: llamacpp-api
* Models folder: llamacpp-docker/models:/app/models
* Default API port: 8000

### Stop & Remove Container

docker stop llamacpp-api
docker rm llamacpp-api

### Rebuild Docker Image

docker build -t llamacpp-api llamacpp-docker

---

### ⚡ Understanding Container States

Docker distinguishes between running containers and all containers:

* docker ps → shows only running containers
* docker ps -a → shows all containers, including stopped/exited ones

A container that has exited (status Exited (1)) will not appear in docker ps but still exists in Docker. Its name is reserved until you remove it.

---

### ⚡ Common Name Conflict

If you try to run a container with a name already in use:

docker run -d -p 8000:8000 --name llamacpp-api llamacpp-api

You might see:

Conflict. The container name "/llamacpp-api" is already in use...

This happens because Docker does not allow two containers with the same name, even if the old one is stopped.

Fix options:

Option 1: Remove the old container
docker rm llamacpp-api
docker run -d -p 8000:8000 --name llamacpp-api llamacpp-api

Option 2: Use a new container name
docker run -d -p 8000:8000 --name llamacpp-api2 llamacpp-api

---

### ⚡ Troubleshooting Exiting Containers

If the container immediately exits (Exited (1)), check:

docker logs llamacpp-api

Or run interactively:

docker run -it --rm -p 8000:8000 llamacpp-api bash
uvicorn llama_api:app --host 0.0.0.0 --port 8000

Common causes:

* Model file missing inside the container
* Python dependencies missing
* Path or permission issues

---

### ⚡ Accessing the API

curl "http://localhost:8000/generate?prompt=Hello+world"

Make sure the container is running before curling. docker ps should show it.

---

### ⚡ Tips

* Always run setup_llamacpp.sh to keep everything up to date
* You can change the Docker port or image name in the script
* To reset Docker, remove old containers and images before rerunning

---
