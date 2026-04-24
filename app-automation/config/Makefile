.PHONY: help local build test deploy clean logs ps

help:
	@echo "╔════════════════════════════════════════════════╗"
	@echo "║  Task Management App - Makefile Commands      ║"
	@echo "╚════════════════════════════════════════════════╝"
	@echo ""
	@echo "Local Development:"
	@echo "  make local       - Start app locally with docker-compose"
	@echo "  make build       - Build Docker images"
	@echo "  make test        - Run backend tests"
	@echo "  make logs        - View docker-compose logs"
	@echo "  make ps          - Show running containers"
	@echo "  make clean       - Stop and remove containers"
	@echo ""
	@echo "Backend Development:"
	@echo "  make backend-shell  - Access backend container shell"
	@echo "  make backend-logs   - View backend logs"
	@echo ""
	@echo "Azure Deployment:"
	@echo "  make azure-init     - Initialize Terraform"
	@echo "  make azure-plan     - Plan Azure infrastructure"
	@echo "  make azure-deploy   - Deploy to Azure"
	@echo "  make azure-destroy  - Destroy Azure infrastructure"
	@echo ""
	@echo "Kubernetes:"
	@echo "  make k8s-deploy     - Deploy to Kubernetes"
	@echo "  make k8s-logs       - View Kubernetes logs"
	@echo "  make k8s-status     - Show K8s status"
	@echo ""

# Local Development
local:
	@echo "🚀 Starting application locally..."
	@chmod +x scripts/local-setup.sh
	@bash scripts/local-setup.sh

build:
	@echo "🔨 Building Docker images..."
	@docker-compose build

test:
	@echo "🧪 Running tests..."
	@docker-compose exec backend pip install -r requirements.txt
	@docker-compose exec backend pytest test_app.py -v --cov=. --cov-report=html

logs:
	@docker-compose logs -f

ps:
	@docker-compose ps

clean:
	@echo "🧹 Cleaning up..."
	@docker-compose down -v

# Backend Development
backend-shell:
	@docker-compose exec backend bash

backend-logs:
	@docker-compose logs backend -f

# Azure Deployment
azure-init:
	@echo "📦 Initializing Terraform..."
	@cd terraform && terraform init

azure-plan:
	@echo "📋 Planning Azure infrastructure..."
	@cd terraform && terraform plan

azure-deploy:
	@echo "☁️  Deploying to Azure..."
	@chmod +x scripts/deploy-azure.sh
	@bash scripts/deploy-azure.sh

azure-destroy:
	@echo "⚠️  Destroying Azure infrastructure..."
	@cd terraform && terraform destroy -auto-approve

# Kubernetes
k8s-deploy:
	@echo "☸️  Deploying to Kubernetes..."
	@chmod +x kubernetes/deploy.sh
	@bash kubernetes/deploy.sh

k8s-logs:
	@kubectl logs -f deployment/backend-deployment

k8s-status:
	@echo "📊 Kubernetes Status:"
	@echo ""
	@echo "Deployments:"
	@kubectl get deployments
	@echo ""
	@echo "Services:"
	@kubectl get services
	@echo ""
	@echo "Pods:"
	@kubectl get pods -o wide
	@echo ""
	@echo "Events:"
	@kubectl get events

# Development helpers
install-deps:
	@echo "📥 Installing dependencies..."
	@pip install -r backend/requirements.txt

lint:
	@echo "🔍 Linting code..."
	@pylint backend/app.py

format:
	@echo "✨ Formatting code..."
	@black backend/app.py

check-health:
	@echo "❤️  Checking application health..."
	@curl -s http://localhost:5000/health | python -m json.tool || echo "Backend not responding"
	@curl -s http://localhost/ > /dev/null && echo "✅ Frontend is up" || echo "❌ Frontend is down"
