#!/bin/bash

# Update system packages
apt-get update
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker azureuser

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Kubernetes tools
apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install Minikube for Kubernetes
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

# Install K3s as an alternative to Minikube (lighter weight)
curl -sfL https://get.k3s.io | sh -

# Clone the application repository
mkdir -p /opt/app-automation
cd /opt/app-automation
git clone https://github.com/$GITHUB_REPO /opt/app-automation || echo "Repository already cloned"

# Setup docker-compose for local development
cd /opt/app-automation
docker-compose up -d || true

echo "VM initialization completed!"
