#!/bin/bash

# Build images locally
echo "Building Docker images..."
docker-compose build

# Tag images for local registry
docker tag app-automation_backend:latest localhost:5000/task-backend:latest
docker tag app-automation_frontend:latest localhost:5000/task-frontend:latest

echo "Images built successfully!"
