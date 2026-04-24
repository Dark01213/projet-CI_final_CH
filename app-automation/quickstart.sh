#!/bin/bash

# Quick Start Script pour le projet

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Task Management App - Automated Deployment              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"
echo ""

# Menu
echo -e "${YELLOW}Choose deployment option:${NC}"
echo "1) Local development (Docker Compose)"
echo "2) Azure + Kubernetes deployment"
echo "3) View status"
echo "4) Cleanup"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo -e "${BLUE}Starting local development environment...${NC}"
        docker-compose up -d
        
        sleep 5
        
        echo ""
        echo -e "${GREEN}✓ Application started!${NC}"
        echo ""
        echo -e "${YELLOW}Access your application:${NC}"
        echo "  Frontend:     ${BLUE}http://localhost${NC}"
        echo "  Backend:      ${BLUE}http://localhost:5000${NC}"
        echo "  Health Check: ${BLUE}http://localhost:5000/health${NC}"
        echo ""
        echo -e "${YELLOW}Useful commands:${NC}"
        echo "  View logs:    docker-compose logs -f"
        echo "  Stop:         docker-compose down"
        echo "  Run tests:    docker-compose exec backend pytest test_app.py -v"
        ;;
    
    2)
        echo -e "${BLUE}Azure + Kubernetes deployment${NC}"
        
        # Check if Terraform is installed
        if ! command -v terraform &> /dev/null; then
            echo -e "${RED}✗ Terraform is not installed${NC}"
            echo "Install Terraform: https://www.terraform.io/downloads.html"
            exit 1
        fi
        
        # Check if kubectl is installed
        if ! command -v kubectl &> /dev/null; then
            echo -e "${RED}✗ kubectl is not installed${NC}"
            echo "Install kubectl: https://kubernetes.io/docs/tasks/tools/"
            exit 1
        fi
        
        # Check if az CLI is installed
        if ! command -v az &> /dev/null; then
            echo -e "${RED}✗ Azure CLI is not installed${NC}"
            echo "Install Azure CLI: https://learn.microsoft.com/cli/azure/install-azure-cli"
            exit 1
        fi
        
        echo -e "${GREEN}✓ All tools are installed${NC}"
        echo ""
        
        # Check Azure login
        echo -e "${YELLOW}Checking Azure authentication...${NC}"
        if ! az account show &> /dev/null; then
            echo -e "${YELLOW}Please login to Azure:${NC}"
            az login
        fi
        
        echo ""
        echo -e "${BLUE}Deploying infrastructure...${NC}"
        
        cd terraform
        
        echo -e "${YELLOW}Initializing Terraform...${NC}"
        terraform init
        
        echo -e "${YELLOW}Planning deployment...${NC}"
        terraform plan
        
        echo ""
        read -p "Do you want to apply these changes? (yes/no): " confirm
        
        if [ "$confirm" = "yes" ]; then
            echo -e "${BLUE}Applying deployment...${NC}"
            terraform apply -auto-approve
            
            # Get outputs
            IP=$(terraform output -raw public_ip_address)
            
            echo ""
            echo -e "${GREEN}✓ Infrastructure deployed!${NC}"
            echo ""
            echo -e "${YELLOW}Next steps:${NC}"
            echo "1. SSH into VM: ssh -i ~/.ssh/id_rsa azureuser@$IP"
            echo "2. cd /opt/app-automation"
            echo "3. docker-compose up -d"
            echo "4. bash kubernetes/deploy.sh"
            echo ""
            echo -e "${YELLOW}Access application:${NC}"
            echo "  Frontend: http://$IP:30080"
            echo "  Backend:  http://$IP:5000"
        else
            echo "Deployment cancelled."
        fi
        
        cd ..
        ;;
    
    3)
        echo -e "${BLUE}Application Status:${NC}"
        echo ""
        echo -e "${YELLOW}Docker Containers:${NC}"
        docker-compose ps
        echo ""
        echo -e "${YELLOW}Kubernetes Nodes:${NC}"
        kubectl get nodes 2>/dev/null || echo "Kubernetes not available locally"
        echo ""
        echo -e "${YELLOW}Health Checks:${NC}"
        
        # Check frontend
        if curl -s http://localhost > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Frontend is running${NC}"
        else
            echo -e "${RED}✗ Frontend is not responding${NC}"
        fi
        
        # Check backend
        if curl -s http://localhost:5000/health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Backend is running${NC}"
        else
            echo -e "${RED}✗ Backend is not responding${NC}"
        fi
        ;;
    
    4)
        echo -e "${YELLOW}Cleanup options:${NC}"
        echo "1) Stop Docker containers"
        echo "2) Remove containers and volumes"
        echo "3) Remove Docker images"
        echo "4) Destroy Azure resources (Terraform)"
        echo ""
        
        read -p "Enter your choice (1-4): " cleanup_choice
        
        case $cleanup_choice in
            1)
                echo -e "${BLUE}Stopping containers...${NC}"
                docker-compose stop
                echo -e "${GREEN}✓ Containers stopped${NC}"
                ;;
            2)
                echo -e "${BLUE}Removing containers and volumes...${NC}"
                docker-compose down -v
                echo -e "${GREEN}✓ Cleaned up${NC}"
                ;;
            3)
                echo -e "${BLUE}Removing images...${NC}"
                docker-compose down -v --rmi all
                echo -e "${GREEN}✓ Images removed${NC}"
                ;;
            4)
                echo -e "${YELLOW}⚠️  This will destroy Azure resources!${NC}"
                read -p "Are you sure? (yes/no): " destroy_confirm
                
                if [ "$destroy_confirm" = "yes" ]; then
                    cd terraform
                    terraform destroy -auto-approve
                    cd ..
                    echo -e "${GREEN}✓ Azure resources destroyed${NC}"
                else
                    echo "Destroy cancelled."
                fi
                ;;
        esac
        ;;
    
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Done!${NC}"
