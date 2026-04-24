# 🛠️ Commandes utiles - Guide de référence rapide

## 🚀 Démarrage rapide

```bash
# Démarrage local ultra-rapide
chmod +x quickstart.sh
./quickstart.sh

# OU avec Makefile
make help          # Voir toutes les commandes
make local         # Démarrer localement
```

## 🐳 Docker et Docker Compose

### Gestion des services

```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Redémarrer les services
docker-compose restart

# Voir les services en cours
docker-compose ps

# Reconstruire les images
docker-compose build

# Construire et démarrer
docker-compose up -d --build
```

### Logs et debugging

```bash
# Voir tous les logs en temps réel
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend

# Voir les dernières 100 lignes
docker-compose logs --tail=100 backend

# Accéder au shell d'un conteneur
docker-compose exec backend bash
docker-compose exec frontend sh

# Exécuter une commande
docker-compose exec backend pip list
docker-compose exec backend python --version
```

### Données et volumes

```bash
# Supprimer tous les conteneurs et volumes
docker-compose down -v

# Supprimer les images aussi
docker-compose down -v --rmi all

# Nettoyer tout (conteneurs, images, volumes, networks)
docker system prune -a --volumes
```

## 🧪 Tests et qualité de code

```bash
# Exécuter les tests
docker-compose exec backend pytest test_app.py -v

# Tests avec coverage
docker-compose exec backend pytest test_app.py --cov=. --cov-report=html

# Voir le rapport de coverage
# Ouvrir: htmlcov/index.html

# Tests spécifiques
docker-compose exec backend pytest test_app.py::test_health_endpoint -v

# Mode watch (re-run tests on change)
docker-compose exec backend pytest-watch test_app.py
```

## 📦 Gestion des dépendances

```bash
# Backend
docker-compose exec backend pip install -r requirements.txt
docker-compose exec backend pip list
docker-compose exec backend pip install <package-name>

# Frontend
docker-compose exec frontend npm install
docker-compose exec frontend npm list
```

## 🔍 Vérifications de santé

```bash
# Health check endpoint
curl http://localhost:5000/health

# Pretty print JSON
curl -s http://localhost:5000/health | python -m json.tool

# Avec verbose output
curl -v http://localhost:5000/health

# Test l'API complète
curl http://localhost:5000/api/tasks | python -m json.tool

# Créer une tâche
curl -X POST http://localhost:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "My Task", "description": "Test"}'

# Frontend
curl -s http://localhost | head -20  # Voir le HTML
```

## 🎯 Développement local avec Makefile

```bash
make help              # Voir toutes les commandes

# Local Development
make local             # Démarrer localement
make build             # Construire les images
make test              # Exécuter les tests
make logs              # Voir les logs
make ps                # Voir les conteneurs
make clean             # Nettoyer

# Backend
make backend-shell     # Accéder au shell backend
make backend-logs      # Voir logs backend

# Azure
make azure-init        # Initialiser Terraform
make azure-plan        # Planifier déploiement
make azure-deploy      # Déployer sur Azure
make azure-destroy     # Détruire infrastructure

# Kubernetes
make k8s-deploy        # Déployer sur K8s
make k8s-logs          # Voir logs K8s
make k8s-status        # Voir status K8s

# Development helpers
make install-deps      # Installer dépendances
make lint              # Vérifier le code
make format            # Formatter le code
make check-health      # Vérifier la santé
```

## 🧪 Tests et Validation

### Tests Backend (Python/pytest)

```bash
cd backend

# Exécuter tous les tests
python -m pytest test_app.py -v

# Tests avec couverture
python -m pytest test_app.py --cov=. --cov-report=html

# Tests détaillés avec sortie courte
python -m pytest test_app.py -v --tb=short

# Exécuter un test spécifique
python -m pytest test_app.py::test_health_endpoint -v
```

### Tests avec Docker

```bash
# Tests dans les conteneurs (recommandé)
make test

# OU directement avec docker-compose
docker-compose exec backend pytest test_app.py -v
```

### Validation complète

```bash
# Script de validation automatique
./scripts/validate-tests.bat    # Windows
./scripts/validate-tests.sh     # Linux/Mac

# Vérifier la santé des services
make check-health

# Tests d'intégration complets
docker-compose up -d
curl http://localhost:8080      # Frontend
curl http://localhost:5000/health  # Backend API
docker-compose down
```

### Tests CI/CD

```bash
# Simuler le pipeline GitHub Actions localement
# (nécessite act: https://github.com/nektos/act)
act -j test

# Vérifier la configuration des secrets
# Voir docs/SECRETS_SETUP.md
```

### Initialisation Azure

```bash
# Installer Azure CLI
# https://learn.microsoft.com/cli/azure/install-azure-cli

# Login
az login

# Lister les souscriptions
az account list

# Sélectionner une souscription
az account set --subscription "subscription-id"

# Vérifier la connexion
az account show
```

### Terraform

```bash
cd terraform

# Initialiser Terraform
terraform init

# Voir le plan (sans appliquer)
terraform plan

# Voir le plan avec détails
terraform plan -detailed-exitcode

# Appliquer les changements
terraform apply
terraform apply -auto-approve  # Sans confirmation

# Détruire les ressources
terraform destroy
terraform destroy -auto-approve  # Sans confirmation

# Voir les outputs
terraform output

# Voir une variable spécifique
terraform output public_ip_address

# Valider la configuration
terraform validate

# Format la configuration
terraform fmt

# Voir l'état Terraform
terraform show

# Voir les ressources spécifiques
terraform state list
terraform state show azurerm_linux_virtual_machine.main
```

## 🔑 Gestion des clés SSH

```bash
# Générer une clé SSH
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Voir la clé publique (à ajouter à authorized_keys)
cat ~/.ssh/id_rsa.pub

# Voir la clé privée (à ajouter comme secret GitHub)
cat ~/.ssh/id_rsa

# Tester la connexion SSH
ssh -i ~/.ssh/id_rsa azureuser@<IP_PUBLIQUE>

# Copier la clé vers la VM
ssh-copy-id -i ~/.ssh/id_rsa.pub azureuser@<IP_PUBLIQUE>

# SSH avec verbose mode (debugging)
ssh -v -i ~/.ssh/id_rsa azureuser@<IP_PUBLIQUE>
```

## ☸️ Kubernetes (sur la VM)

```bash
# Accéder à la VM d'abord
ssh -i ~/.ssh/id_rsa azureuser@<IP_PUBLIQUE>

# Vérifier l'installation K3s
sudo kubectl get nodes
sudo kubectl cluster-info

# Voir les deployments
sudo kubectl get deployments
sudo kubectl get deployments -o wide

# Voir les services
sudo kubectl get services
sudo kubectl get svc

# Voir les pods
sudo kubectl get pods
sudo kubectl get pods -o wide
sudo kubectl get pods -A  # Tous les namespaces

# Voir les configmaps
sudo kubectl get configmap

# Déployer les manifests
cd /opt/app-automation
sudo bash kubernetes/deploy.sh

# Ou appliquer manuellement
sudo kubectl apply -f kubernetes/configmap.yaml
sudo kubectl apply -f kubernetes/backend-deployment.yaml
sudo kubectl apply -f kubernetes/frontend-deployment.yaml

# Monitoring des deployments
sudo kubectl rollout status deployment/backend-deployment
sudo kubectl rollout status deployment/frontend-deployment

# Logs Kubernetes
sudo kubectl logs deployment/backend-deployment
sudo kubectl logs -f deployment/backend-deployment  # En temps réel
sudo kubectl logs -f <POD_NAME> -c <CONTAINER_NAME>

# Debugging
sudo kubectl describe pod <POD_NAME>
sudo kubectl describe deployment/backend-deployment
sudo kubectl describe service backend-service

# Événements
sudo kubectl get events
sudo kubectl get events --sort-by='.lastTimestamp'

# Resource usage
sudo kubectl top pods
sudo kubectl top nodes

# Port forwarding (test)
sudo kubectl port-forward svc/backend-service 5000:5000

# Accéder au shell du pod
sudo kubectl exec -it <POD_NAME> -- bash

# Redémarrer un deployment
sudo kubectl rollout restart deployment/backend-deployment

# Voir la configuration appliquée
sudo kubectl get deployment/backend-deployment -o yaml
```

## 📝 Git et GitHub

```bash
# Initialiser repo local
git init
git add .
git commit -m "Initial commit"

# Ajouter le remote
git remote add origin https://github.com/username/app-automation.git

# Push vers GitHub
git branch -M main
git push -u origin main

# Voir l'historique
git log --oneline
git log --graph --oneline --all

# Voir le statut
git status
git diff

# Commits et branches
git branch -a              # Voir toutes les branches
git checkout -b feature    # Créer nouvelle branche
git push origin feature    # Push la branche

# Undo changes
git restore file.txt       # Annuler changements d'un fichier
git reset HEAD~1           # Annuler le dernier commit
git revert <COMMIT_ID>     # Créer un commit qui annule un changement

# Tags
git tag v1.0.0
git push origin v1.0.0
```

## 🔐 Secrets GitHub

```bash
# Configurer les secrets via CLI (si possible) ou interface web:
# Settings > Secrets and variables > Actions > New repository secret

# Secrets nécessaires:
VM_HOST       = <IP_PUBLIQUE_AZURE>
VM_USERNAME   = azureuser
VM_SSH_KEY    = <CONTENU_DE_~/.ssh/id_rsa>
```

## 🎯 Scripts personnalisés

```bash
# Rendre exécutable
chmod +x scripts/local-setup.sh
chmod +x scripts/build-images.sh
chmod +x scripts/deploy-azure.sh
chmod +x kubernetes/deploy.sh
chmod +x quickstart.sh
chmod +x setup-github.sh

# Exécuter
./scripts/local-setup.sh
./scripts/build-images.sh
./scripts/deploy-azure.sh
bash kubernetes/deploy.sh
```

## 📊 Monitoring et performance

```bash
# Docker stats (utilisation CPU/RAM)
docker stats

# Docker images
docker images
docker images -a

# Docker containers
docker ps          # Conteneurs actifs
docker ps -a       # Tous les conteneurs

# Disk usage
docker system df
docker system df -v

# Network
docker network ls
docker network inspect <NETWORK_NAME>
```

## 🧹 Nettoyage et maintenance

```bash
# Supprimer les images non utilisées
docker image prune

# Supprimer les conteneurs arrêtés
docker container prune

# Supprimer les volumes non utilisés
docker volume prune

# Supprimer tout (attention!)
docker system prune -a --volumes

# Voir ce qui sera supprimé
docker system prune --dry-run
```

## 🐛 Troubleshooting rapide

```bash
# Port déjà utilisé
# Trouver le processus utilisant le port 5000
lsof -i :5000
# Tuer le processus
kill -9 <PID>

# Conteneur ne démarre pas
docker logs <CONTAINER_ID>
docker inspect <CONTAINER_ID>

# Network issues
docker network inspect bridge
docker network inspect <APP_NETWORK_NAME>

# Permission denied
sudo usermod -aG docker $USER
newgrp docker

# Certificate issues (Docker login)
docker logout
docker login registry.example.com
```

## 💡 Tips et astuces

```bash
# Alias pour des commandes longues
alias dc='docker-compose'
alias k='sudo kubectl'

# Voir uniquement les conteneurs qui tournent
docker ps --filter "status=running"

# Voir les conteneurs avec un label spécifique
docker ps --filter "label=app=task-app"

# Exporter/Importer images
docker save image_name > image.tar
docker load < image.tar

# Stats en temps réel
watch -n 1 'docker stats --no-stream'

# Backup et restore volume
docker run --rm -v <VOLUME_NAME>:/data -v $(pwd):/backup alpine tar cvf /backup/backup.tar /data
docker run --rm -v <VOLUME_NAME>:/data -v $(pwd):/backup alpine tar xvf /backup/backup.tar
```

## 📚 Ressources de commandes

```bash
# Aide intégrée
docker --help
docker-compose --help
kubectl --help
terraform --help

# Man pages
man docker
man docker-compose

# Versions
docker --version
docker-compose --version
kubectl version --client
terraform --version
git --version
python --version
```

---

**Conseil**: Créer des alias pour les commandes fréquentes:

```bash
# Dans ~/.bashrc ou ~/.zshrc
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'
alias gs='git status'
alias gl='git log --oneline -10'
```

**Puis recharg**: `source ~/.bashrc`
