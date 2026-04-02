# LlamaCPP Docker & API Setup

This repository provides a **full LlamaCPP Docker environment** with a Python API interface. It allows you to run Llama models locally via Docker and interact with them using Python scripts.

---

## 📁 Repository Contents

| File | Description |
|------|-------------|
| `Dockerfile` | Builds the LlamaCPP API Docker image. |
| `requirements.txt` | Python dependencies for API usage. |
| `setup_llamacpp.sh` | Bash script to install Docker, download models, build the Docker image, and run the container. |
| `llama_api.py` | Python wrapper for interacting with the LlamaCPP API. |
| `example_request.py` | Example Python script demonstrating how to send prompts to the API. |

---

## 🚀 Setup Instructions

### 1. Make the Script Executable

```bash
chmod +x setup_llamacpp.sh
```

### 2. Run the Setup Script

```bash
./setup_llamacpp.sh
```

The script performs the following:

1. Checks if `git` is installed, and installs it if missing.  
2. Removes old Docker and Podman remnants.  
3. Installs Docker official packages and prerequisites.  
4. Clones or updates the `llamacpp-docker` repository.  
5. Ensures the `models` folder exists.  
6. Downloads the specified Llama model if not already present.  
7. Builds the Docker image named `llamacpp-api`.  
8. Stops and removes any existing container named `llamacpp-api`.  
9. Runs a new container named `llamacpp-api` on port 8000.  

> After the script completes, the container will be running and ready to accept requests.

---

## ✅ Test the API

Test the running container with `curl`:

```bash
curl 'http://localhost:8000/generate?prompt=Hello+world'
```

You should receive a JSON response from the LlamaCPP model.

---

## 🐍 Python API Usage

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Example Usage

```python
from llama_api import LlamaAPI

api = LlamaAPI("http://localhost:8000")
response = api.generate("Hello world")
print(response)
```

### 3. Run the Example Script

```bash
python example_request.py
```

---

## 🐳 Docker Notes

- **Image name:** `llamacpp-api`  
- **Container name:** `llamacpp-api`  
- **Models folder:** `llamacpp-docker/models:/app/models`  
- **Default API port:** 8000  

### Stop & Remove Container

```bash
docker stop llamacpp-api
docker rm llamacpp-api
```

### Rebuild Docker Image

```bash
docker build -t llamacpp-api llamacpp-docker
```

---

## ⚡ Tips

- Always run `setup_llamacpp.sh` to ensure Docker, the model, and repo are up to date.  
- You can change the Docker port or image name by editing the `docker run` command at the end of the script.  
- To reset Docker entirely, remove all old containers and images before re-running the script.  

---
