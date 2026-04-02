#!/bin/bash

# ==================================================
# Full setup for LlamaCPP Docker environment
# ==================================================

set -e  # Exit on any error

REPO_SSH="git@github.com:omgitsgb/llamacpp-docker.git"
FOLDER="llamacpp-docker"
MODEL="llama-3.2-1b-instruct-q8_0.gguf"
MODEL_URL="https://huggingface.co/hugging-quants/Llama-3.2-1B-Instruct-Q8_0-GGUF/resolve/main/$MODEL"

# --------------------------
# 1. Check for git
# --------------------------
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing..."
    sudo apt update
    sudo apt install -y git
else
    echo "Git is already installed."
fi

# --------------------------
# 2. Remove old Docker / Podman remnants
# --------------------------
echo "Removing old Docker / Podman packages..."
sudo apt remove -y $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) || true
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || true
sudo apt-get autoremove -y || true
sudo rm -rf /var/lib/docker /var/lib/containerd /etc/docker /etc/apt/keyrings/docker* /etc/apt/sources.list.d/docker*


# --------------------------
# 3. Install Docker official packages
# --------------------------
echo "Installing Docker prerequisites..."
sudo apt update
sudo apt install -y ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository using sources file
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update apt and install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify Docker installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker installation failed. Exiting."
    exit 1
fi

# --------------------------
# 4. Clone or update repo
# --------------------------
if [ -d "$FOLDER" ]; then
    echo "Repo exists, pulling latest changes..."
    cd "$FOLDER" || exit
    git pull
    cd ..
else
    echo "Cloning repository..."
    git clone "$REPO_SSH"
fi

# --------------------------
# 5. Ensure models folder exists
# --------------------------
mkdir -p "$FOLDER/models"

# --------------------------
# 6. Download model if not present
# --------------------------
if [ ! -f "$FOLDER/models/$MODEL" ]; then
    echo "Downloading model..."
    curl -L "$MODEL_URL" -o "$FOLDER/models/$MODEL"
else
    echo "Model already exists."
fi

# --------------------------
# 7. Build Docker image
# --------------------------
echo "Building Docker image..."
docker build -t llamacpp-api "$FOLDER"

# --------------------------
# 8. Run Docker container
# --------------------------
echo "Running Docker container..."
docker stop llamacpp-api 2>/dev/null || true
docker rm llamacpp-api 2>/dev/null || true
docker run -d -p 8000:8000 --name llamacpp-api llamacpp-api

# --------------------------
# 9. Success message
# --------------------------
echo "✅ Setup complete!"
echo "You can test with:"
echo "curl 'http://localhost:8000/generate?prompt=Hello+world'"
