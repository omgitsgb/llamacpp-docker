# LlamaCPP API Docker Setup

This repository provides a **Dockerized LlamaCPP API** with a Python interface, allowing you to run Llama models locally and send requests via a simple Python script.

---

## 📁 Repository Contents

| File | Description |
|------|-------------|
| `Dockerfile` | Builds the LlamaCPP API Docker image. |
| `requirements.txt` | Python dependencies for the API and example script. |
| `setup_llamacpp.sh` | Bash script to install Docker, clone/update the repo, download models, build the image, and run the container. |
| `llama_api.py` | Python API wrapper for interacting with the LlamaCPP API. |
| `example_request.py` | Example Python script showing how to send a prompt to the API. |

---

## 🚀 Setup Instructions

### 1. Run the Setup Script

This will install Docker (if needed), download the model, build the image, and start the container:

```bash
chmod +x setup_llamacpp.sh
./setup_llamacpp.sh
```

> The script automatically handles container conflicts and volume mapping for the models.

### 2. Verify the API

Test the running API with `curl`:

```bash
curl 'http://localhost:8000/generate?prompt=Hello+world'
```

You should get a JSON response from the LlamaCPP model.

### 3. Using the Python API

Install dependencies:

```bash
pip install -r requirements.txt
```

Example usage:

```python
from llama_api import LlamaAPI

api = LlamaAPI("http://localhost:8000")
response = api.generate("Hello world")
print(response)
```

You can also run the example script directly:

```bash
python example_request.py
```

---

## 🐳 Docker Notes

- Image name: `llamacpp-api`  
- Container name: `llamacpp-api`  
- Models folder is mounted into the container: `llamacpp-docker/models:/app/models`  
- Default API port: `8000`  

To stop/remove the container:

```bash
docker stop llamacpp-api
docker rm llamacpp-api
```

To rebuild the image after changes:

```bash
docker build -t llamacpp-api .
```

---

## ⚡ Tips

- Always run `setup_llamacpp.sh` to ensure you have the latest model and repo updates.
- You can map additional volumes or change ports by editing the `docker run` section in `setup_llamacpp.sh`.
- If you want to reset Docker entirely, use the included cleanup commands before re-running the setup.

---

