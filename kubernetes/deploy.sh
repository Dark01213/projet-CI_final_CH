#!/bin/bash

# Deploy to Kubernetes cluster
echo "Deploying to Kubernetes..."

# Create namespace
kubectl create namespace task-app --dry-run=client -o yaml | kubectl apply -f -

# Apply configurations
kubectl apply -f configmap.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f job.yaml

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/backend-deployment --timeout=5m
kubectl rollout status deployment/frontend-deployment --timeout=5m

echo "Deployment complete!"
echo ""
echo "Services:"
kubectl get services
echo ""
echo "Pods:"
kubectl get pods
echo ""
echo "Access the application:"
echo "Frontend: http://localhost:30080"
