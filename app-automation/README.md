# 📦 Task Management Application - Fullstack CI/CD & Kubernetes

## 🎯 Bienvenue!

Cette application démontre une **solution complète d'automatisation du déploiement** pour une entreprise moderne.

### 👉 **COMMENCER ICI**: [📖 docs/00_START_HERE.md](docs/00_START_HERE.md)

> 💡 **Conseil**: Parcourez la documentation dans l'ordre recommandé (voir `docs/INDEX.md`)

---

## 📁 Structure Thématique du Projet

```
app-automation/                        🎯 RACINE DU PROJET
│
├── 📚 DOCUMENTATION (docs/)
│   ├── 🎯 00_START_HERE.md            ← COMMENCER ICI!
│   ├── 📖 GETTING_STARTED.md          Guide étape par étape
│   ├── 📊 PROJECT_OVERVIEW.md         Vue d'ensemble visuelle
│   ├── ✅ DEPLOYMENT_CHECKLIST.md     Vérifications avant déploiement
│   ├── 🔧 COMMANDS_REFERENCE.md       Toutes les commandes
│   ├── 📋 STRUCTURE.md                Architecture complète
│   ├── 🗂️  INDEX.md                   Index de la documentation
│   ├── 📝 RAPPORT_PROJET.md           Rapport technique
│   ├── 🇫🇷 FINAL_SUMMARY_FR.md       Résumé en français
│   └── 🔐 SECRETS_SETUP.md            Configuration des secrets
│
├── 💻 APPLICATION BACKEND (backend/)
│   ├── 🐍 app.py                      API Flask principale
│   ├── 🧪 test_app.py                 12 tests unitaires complets
│   ├── 📦 requirements.txt             Dépendances Python
│   └── 🐳 Dockerfile                  Image Docker backend
│
├── 🎨 APPLICATION FRONTEND (frontend/)
│   ├── 🌐 index.html                  Page HTML principale
│   ├── 🎭 app.js                      Logique JavaScript
│   ├── 🎨 styles.css                  Styles CSS
│   ├── ⚙️  nginx.conf                  Configuration Nginx
│   ├── 📦 package.json                Métadonnées npm
│   └── 🐳 Dockerfile                  Image Docker frontend
│
├── ☸️  ORCHESTRATION KUBERNETES (kubernetes/)
│   ├── 🚀 backend-deployment.yaml     Déploiement backend
│   ├── 🎨 frontend-deployment.yaml    Déploiement frontend
│   ├── ⚙️  configmap.yaml              Configuration K8s
│   ├── 🔄 job.yaml                    Job de migration
│   └── 📝 deploy.sh                   Script déploiement
│
├── ☁️  INFRASTRUCTURE AZURE (terraform/)
│   ├── 🏗️  main.tf                    Ressources Azure
│   ├── 📋 variables.tf                Variables Terraform
│   ├── 🔧 versions.tf                 Versions providers
│   ├── 📝 terraform.tfvars            Valeurs variables
│   └── 🚀 init-script.sh              Installation VM
│
├── 🔄 CI/CD PIPELINE (.github/workflows/)
│   ├── 🤖 ci-cd.yml                   Workflow principal
│   └── ℹ️  info.yml                    Workflow info
│
├── 🛠️  SCRIPTS UTILITAIRES (scripts/)
│   ├── 🔧 local-setup.sh              Configuration locale
│   ├── 🏗️  build-images.sh            Build Docker
│   └── ☁️  deploy-azure.sh            Déploiement Azure
│
├── 📋 CONFIGURATION (config/)
│   ├── 🐳 docker-compose.yml          Orchestration locale
│   ├── 📝 .env.example                Template variables
│   ├── 🚫 .gitignore                  Fichiers ignorés
│   ├── 🔧 Makefile                    Commandes dev
│   └── 📖 README.md                   Guide configuration
│
├── 🚀 SCRIPTS SETUP (setup/)
│   ├── ⚡ quickstart.sh               Démarrage rapide
│   ├── 🔐 setup-github.sh             Setup GitHub Actions
│   └── 📖 README.md                   Guide setup
│
└── 📖 README.md                       CE FICHIER

---

## 🎯 Résumé des dossiers thématiques

| 📁 Dossier | 🎯 Objectif | 📚 Documentation |
|-----------|-----------|-----------------|
| **docs/** | Toute la documentation | [INDEX.md](docs/INDEX.md) |
| **backend/** | API Flask | [app.py](backend/app.py) |
| **frontend/** | Interface web | [index.html](frontend/index.html) |
| **kubernetes/** | Déploiement K8s | [deploy.sh](kubernetes/deploy.sh) |
| **terraform/** | Infrastructure Azure | [main.tf](terraform/main.tf) |
| **.github/workflows/** | CI/CD Pipeline | [ci-cd.yml](.github/workflows/ci-cd.yml) |
| **scripts/** | Utilitaires | [local-setup.sh](scripts/local-setup.sh) |
| **config/** | Configuration | [README.md](config/README.md) |
| **setup/** | Installation | [README.md](setup/README.md) |

---

Cette application fullstack démontre une solution complète d'automatisation du déploiement pour une entreprise souhaitant moderniser son infrastructure. Le projet inclut:

- **Application web complète**: Frontend (HTML/CSS/JS) + Backend API (Flask/Python)
- **Conteneurisation**: Docker avec multi-stage builds
- **Orchestration locale**: Docker Compose pour le développement
- **Orchestration cloud**: Kubernetes pour la production
- **Infrastructure as Code**: Terraform pour provisionner la VM Azure
- **CI/CD Pipeline**: GitHub Actions pour automatiser tests, builds et déploiements

## 🎯 Objectifs réalisés

### ✅ Conteneurisation
- [x] Dockerfile pour le backend (Flask)
- [x] Dockerfile pour le frontend (Nginx)
- [x] Multi-stage build pour optimiser les images
- [x] Health checks intégrés dans les conteneurs

### ✅ Orchestration locale
- [x] Docker Compose pour gérer les services
- [x] Communication inter-services (frontend ↔ backend)
- [x] Volumes pour le développement
- [x] Variables d'environnement

### ✅ Déploiement cloud
- [x] Terraform pour provisionner VM Azure
- [x] Kubernetes manifests (Deployments, Services, ConfigMaps)
- [x] K3s installé sur la VM
- [x] Exposition des services via NodePort

### ✅ Pipeline CI/CD
- [x] GitHub Actions pour automatisation
- [x] Tests unitaires avec coverage
- [x] Build Docker automatique
- [x] Déploiement SSH sur la VM
- [x] Gestion des secrets (variables GitHub)
- [x] Health checks post-déploiement

### ✅ Tests & Validation
- [x] 12 tests unitaires complets pour l'API backend
- [x] Tests de tous les endpoints CRUD (Create, Read, Update, Delete)
- [x] Tests d'erreurs et de validation
- [x] Tests de health checks
- [x] Scripts de validation automatisés
- [x] Guide de test complet ([docs/TESTING_GUIDE.md](docs/TESTING_GUIDE.md))
- [x] Intégration dans le pipeline CI/CD

## 📁 Structure du projet

```
app-automation/
├── backend/                      # API Flask
│   ├── app.py                   # Application principale
│   ├── test_app.py              # Tests unitaires
│   ├── requirements.txt          # Dépendances Python
│   └── Dockerfile               # Build du backend
├── frontend/                     # Interface web
│   ├── index.html               # HTML principal
│   ├── app.js                   # Logique JavaScript
│   ├── styles.css               # Styles CSS
│   ├── nginx.conf               # Configuration Nginx
│   ├── package.json             # Métadonnées npm
│   └── Dockerfile               # Build du frontend
├── kubernetes/                   # Déploiement K8s
│   ├── backend-deployment.yaml  # Déploiement backend
│   ├── frontend-deployment.yaml # Déploiement frontend
│   ├── configmap.yaml           # Configuration centralisée
│   ├── job.yaml                 # Job de migration
│   └── deploy.sh                # Script de déploiement
├── terraform/                    # Infrastructure Azure
│   ├── main.tf                  # Ressources Azure
│   ├── variables.tf             # Variables
│   ├── versions.tf              # Configuration Terraform
│   ├── terraform.tfvars         # Valeurs des variables
│   └── init-script.sh           # Installation VM
├── .github/workflows/            # Pipelines CI/CD
│   └── ci-cd.yml                # Workflow GitHub Actions
├── scripts/                      # Scripts utilitaires
│   ├── local-setup.sh           # Configuration locale
│   ├── build-images.sh          # Build des images
│   └── deploy-azure.sh          # Déploiement Azure
├── docker-compose.yml           # Orchestration locale
└── README.md                    # Ce fichier
```

## 🚀 Démarrage rapide

### Prérequis

- **Local**: Docker, Docker Compose
- **Azure**: Abonnement Azure, Terraform
- **Kubernetes**: kubectl, K3s ou Minikube
- **CI/CD**: GitHub account avec GitHub Actions

### 1️⃣ Exécution locale

```bash
# Cloner le projet
git clone https://github.com/votreusername/app-automation
cd app-automation

# Rendre les scripts exécutables
chmod +x scripts/*.sh

# Lancer l'application
./scripts/local-setup.sh

# L'application est maintenant accessible:
# - Frontend: http://localhost
# - Backend: http://localhost:5000
# - Health: http://localhost:5000/health
```

### Commandes Docker Compose utiles

```bash
# Démarrer les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Reconstruire les images
docker-compose build

# Accéder au shell du backend
docker-compose exec backend bash
```

## ☁️ Déploiement sur Azure

### Étape 1: Configuration Azure

```bash
# Installer Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Se connecter à Azure
az login

# Définir la souscription par défaut
az account set --subscription "subscription-id"

# Créer une clé SSH (si non existante)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

### Étape 2: Déploiement Terraform

```bash
# Naviguer au dossier Terraform
cd terraform

# Initialiser Terraform
terraform init

# Voir le plan de déploiement
terraform plan

# Appliquer le déploiement
terraform apply

# Récupérer l'IP publique
terraform output public_ip_address
```

### Étape 3: Configuration de la VM

```bash
# Se connecter via SSH
ssh -i ~/.ssh/id_rsa azureuser@<IP_PUBLIQUE>

# Cloner le projet
git clone https://github.com/votreusername/app-automation /opt/app-automation
cd /opt/app-automation

# Démarrer avec docker-compose
docker-compose up -d

# Vérifier le statut
docker-compose ps

# Voir les logs
docker-compose logs -f
```

### Étape 4: Déploiement Kubernetes

```bash
# Sur la VM:
# Vérifier que K3s est installé
sudo kubectl get nodes

# Déployer l'application
cd /opt/app-automation
sudo bash kubernetes/deploy.sh

# Vérifier le déploiement
sudo kubectl get deployments
sudo kubectl get services
sudo kubectl get pods

# Accéder à l'application
# Frontend: http://<IP_PUBLIQUE>:30080
# Backend: http://<IP_PUBLIQUE>:5000
```

## 🔄 Pipeline CI/CD GitHub Actions

### Configuration

1. **Créer le dépôt GitHub** et pousser le code
2. **Configurer les secrets** dans Settings > Secrets and variables > Actions:

```bash
VM_HOST           = IP publique de la VM
VM_USERNAME       = azureuser
VM_SSH_KEY        = Contenu de ~/.ssh/id_rsa (clé privée)
```

### Flow du pipeline

```
git push (main)
    ↓
CI - Checkout code
    ↓
CI - Setup Python & Install dependencies
    ↓
Tests - Run pytest backend tests
    ↓
Coverage - Upload reports
    ↓
Build - Build Docker images
    ↓
Build - Push images to registry
    ↓
Deploy - SSH to VM
    ↓
Deploy - Pull latest code
    ↓
Deploy - Update docker-compose
    ↓
Deploy - Update Kubernetes
    ↓
Health Check - Verify application
```

### Déclenchement

- Automatique sur `git push` vers `main` ou `develop`
- Sur les Pull Requests vers `main`

### Arrêt du pipeline

Le pipeline s'arrête et échoue si:
- Les tests échouent (⛔ crítico)
- Le build Docker échoue
- Le déploiement SSH échoue
- Les health checks échouent

## 🔐 Gestion des secrets et variables

### Variables d'environnement

Les variables d'environnement sont gérées par:

```yaml
# Local (docker-compose.yml)
environment:
  - FLASK_APP=app.py
  - ENVIRONMENT=development

# Kubernetes (configmap.yaml)
apiVersion: v1
kind: ConfigMap
data:
  environment: "production"
  api_url: "http://backend-service:5000"
```

### Secrets (jamais en clair)

```bash
# GitHub Secrets pour CI/CD
- VM_SSH_KEY: Clé privée SSH (jamais pushée)
- VM_HOST: IP de la VM

# Local .env (dans .gitignore)
DEBUG=True
SECRET_KEY=<random-key>
```

## 📊 Endpoints API

### Health Check
```bash
GET /health
Response: { "status": "healthy", "timestamp": "...", "service": "backend-api" }
```

### Gestion des tâches

```bash
# Récupérer toutes les tâches
GET /api/tasks

# Créer une tâche
POST /api/tasks
Body: { "title": "...", "description": "..." }

# Récupérer une tâche
GET /api/tasks/<id>

# Mettre à jour une tâche
PUT /api/tasks/<id>
Body: { "completed": true }

# Supprimer une tâche
DELETE /api/tasks/<id>

# Info application
GET /api/info
```

## 🧪 Tests

### Local

```bash
# Backend - Tests unitaires
cd backend
pip install -r requirements.txt
pytest test_app.py -v

# Avec coverage
pytest test_app.py --cov=. --cov-report=html
```

### Dans le pipeline CI/CD

Les tests s'exécutent automatiquement et le pipeline échoue si les tests ne passent pas.

## 📈 Monitoring et logs

### Local

```bash
# Tous les logs
docker-compose logs

# Logs en temps réel
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs backend -f

# Rechercher dans les logs
docker-compose logs | grep "error"
```

### Sur la VM

```bash
# Logs docker-compose
tail -f /var/log/docker.log

# Logs Kubernetes
kubectl logs deployment/backend-deployment
kubectl logs deployment/frontend-deployment

# Events Kubernetes
kubectl get events

# Monitoring des ressources
kubectl top pods
kubectl top nodes
```

## 🔧 Troubleshooting

### Le backend ne démarre pas

```bash
# Vérifier les logs
docker-compose logs backend

# Vérifier que le port 5000 est libre
lsof -i :5000

# Redémarrer le service
docker-compose restart backend
```

### Le frontend ne se connecte pas au backend

```bash
# Vérifier la communication
docker-compose exec frontend curl http://backend:5000/health

# Vérifier les variables d'environnement
docker-compose config | grep API_URL

# Vérifier la configuration Nginx
docker-compose exec frontend cat /etc/nginx/conf.d/default.conf
```

### Problème de déploiement Kubernetes

```bash
# Vérifier le statut des pods
kubectl get pods -o wide

# Voir les erreurs
kubectl describe pod <pod-name>

# Voir les logs
kubectl logs <pod-name>

# Vérifier les services
kubectl get services

# Vérifier les déploiements
kubectl get deployments

# Redéployer
kubectl rollout restart deployment/backend-deployment
```

### Le pipeline CI/CD échoue

1. Vérifier les logs GitHub Actions (Actions tab)
2. Vérifier les secrets configurés
3. Tester localement d'abord
4. Vérifier la connectivité SSH à la VM

```bash
# Sur votre machine
ssh -i ~/.ssh/id_rsa -v azureuser@<IP_PUBLIQUE>
```

## 🔄 Mise à jour de l'application

### Pour une nouvelle version

```bash
# Local
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin main

# Le pipeline CI/CD se déclenche automatiquement:
# 1. Tests
# 2. Build images Docker
# 3. Push sur registry
# 4. Déploiement sur VM
# 5. Mise à jour Kubernetes
```

## 📚 Ressources et documentations

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [K3s Documentation](https://docs.k3s.io/)

## 🐛 Difficultés rencontrées et solutions

### 1. Communication entre services Docker
**Problème**: Le frontend ne pouvait pas accéder au backend
**Solution**: Utilisation du DNS interne Docker (nom du service) et configuration du bridge network

### 2. Configuration Nginx pour SPA
**Problème**: Les routes Vue/React ne fonctionnaient pas au rechargement
**Solution**: Configuration de `try_files $uri $uri/ /index.html;` dans nginx.conf

### 3. Multi-stage build
**Problème**: Images trop volumineuses
**Solution**: Utilisation de builder stages pour compiler/tester sans dépendances de dev

### 4. Secrets en CI/CD
**Problème**: Exposition accidentelle de secrets
**Solution**: Utilisation exclusivement de GitHub Secrets (jamais en clair dans le code)

### 5. Health checks dans Kubernetes
**Problème**: Pods au statut "Ready" mais non fonctionnels
**Solution**: Ajout de readinessProbe et livenessProbe avec délais appropriés

### 6. Permissions Terraform Azure
**Problème**: Erreur d'authentification
**Solution**: Utilisation de `az login` et permissions RBAC correctement configurées

## 📝 Checklist de déploiement

- [ ] Code pushé et tests validés
- [ ] Images Docker buildées localement
- [ ] Secrets GitHub configurés
- [ ] VM Azure déployée avec Terraform
- [ ] Docker Compose fonctionne sur la VM
- [ ] Kubernetes est installé et running
- [ ] Application accessible via IP publique
- [ ] Health checks passent
- [ ] Pipeline CI/CD complète sans erreur
- [ ] Logs et monitoring configurés

## 📞 Support et contribution

Pour les problèmes ou améliorations:
1. Créer une issue GitHub
2. Proposer une PR avec vos changements
3. Tester localement avant de soumettre

## 📄 Licence

Ce projet est fourni à titre d'exemple éducatif.

---

**Version**: 1.0.0
**Dernière mise à jour**: 2024
**Mainteneur**: Équipe DevOps
