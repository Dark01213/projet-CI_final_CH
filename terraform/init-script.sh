#!/bin/bash

# Script d'initialisation pour la VM Azure
# Ce script est exécuté automatiquement lors du provisionnement de la VM

echo "=== Initialisation de la VM Azure ==="

# Mise à jour du système
echo "Mise à jour des paquets système..."
apt-get update && apt-get upgrade -y

# Installation de Docker
echo "Installation de Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker azureuser

# Installation de Docker Compose
echo "Installation de Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Installation des outils Kubernetes
echo "Installation des outils Kubernetes..."
apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release

# Installation de kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Installation de Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/minikube

# Installation de K3s (alternative légère à Minikube)
curl -sfL https://get.k3s.io | sh -

# Configuration du firewall
echo "Configuration du firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 5000/tcp
ufw allow 6443/tcp
ufw --force enable

echo "=== Initialisation terminée ==="
echo "VM prête pour le déploiement de l'application!"