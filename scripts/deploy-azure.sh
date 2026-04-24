#!/bin/bash

# Deploy infrastructure on Azure
echo "Deploying infrastructure to Azure..."

# Navigate to terraform directory
cd terraform

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan deployment
echo "Planning deployment..."
terraform plan -out=tfplan

# Apply deployment
echo "Applying deployment..."
terraform apply tfplan

# Get outputs
echo ""
echo "Deployment complete!"
terraform output

echo ""
echo "Next steps:"
echo "1. SSH into the VM: ssh -i ~/.ssh/id_rsa azureuser@<public_ip_address>"
echo "2. Navigate to: cd /opt/app-automation"
echo "3. Start docker-compose: docker-compose up -d"
echo "4. Deploy Kubernetes: bash kubernetes/deploy.sh"
