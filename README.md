# LlamaCPP Docker Setup Script

This repository provides a **full setup script** for running LlamaCPP inside Docker on Ubuntu. The script automates installing Docker, downloading the model, building the Docker image, and running the container.

---

## 📁 Repository Contents

| File | Description |
|------|-------------|
| `setup_llamacpp.sh` | Bash script that installs Docker, downloads the model, builds the image, and runs the container. |
| `llamacpp-docker/` | Repository folder containing the Dockerfile and related files (cloned by the script). |

---

## 🚀 Setup Instructions

### 1. Make the Script Executable

```bash
chmod +x setup_llamacpp.sh
```

### 2. Run the Script

```bash
./setup_llamacpp.sh
```

The script performs the following actions:

1. Checks if `git` is installed, and installs it if missing.  
2. Removes old Docker and Podman packages.  
3. Installs Docker official packages and prerequisites.  
4. Clones or updates the `llamacpp-docker` repository.  
5. Ensures the `models` folder exists.  
6. Downloads the specified Llama model if it is not already present.  
7. Builds the Docker image named `llamacpp-api`.  
8. Stops and removes any existing container named `llamacpp-api`.  
9. Runs a new container named `llamacpp-api` on port 8000.  

> After the script completes, the container will be running and ready to accept requests.

---

## ✅ Test the API

Use `curl` to test the running container:

```bash
curl 'http://localhost:8000/generate?prompt=Hello+world'
```

You should receive a JSON response from the LlamaCPP model.

---

## 🐳 Docker Notes

- Image name: `llamacpp-api`  
- Container name: `llamacpp-api`  
- Exposed API port: `8000`  
- Models folder is mounted inside the container: `llamacpp-docker/models:/app/models`  

### Stop and Remove Container

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

- Always run the script to ensure Docker, the model, and the repository are up to date.  
- If you want to reset Docker completely, you can remove all old containers and images before re-running the script.  
- You can change the Docker port or image name by editing the last section of the script where `docker run` is called.  

---
