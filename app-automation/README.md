# 📦 Task Management Application - Fullstack CI/CD & Kubernetes

## 🎯 Description

Application **fullstack production-ready** démontrant une solution complète d'automatisation du déploiement.

- 🐳 **Docker & Docker Compose** - Containerisation avec multi-stage builds
- ☸️ **Kubernetes (K3s)** - Déploiement scalable en production
- ☁️ **Azure + Terraform** - Infrastructure as Code
- 🤖 **GitHub Actions** - Pipeline CI/CD automatisé
- 🧪 **14 tests unitaires** - Couverture CRUD complète
- 🔐 **Gestion sécurisée** - Zéro exposition de secrets

---

## 🚀 Démarrage Rapide

```bash
# 1. Cloner et naviguer
cd app-automation

# 2. Lancer les services
docker-compose up -d

# 3. Accéder à l'application
# Frontend  : http://localhost
# Backend   : http://localhost:5000
# Health    : http://localhost:5000/health
```

---

## 📊 Architecture

```
App Fullstack
├── Backend (Flask API)
│   ├── 6 endpoints REST
│   ├── Health check (/health)
│   ├── CRUD operations
│   └── 14 tests unitaires
│
└── Frontend (Nginx)
    ├── Interface responsive
    ├── Communication API
    └── HTML/CSS/JS moderne
```

---

## 🐳 Services Docker

- `task-backend` (Flask) → PORT 5000 → 219MB
- `task-frontend` (Nginx) → PORT 80 → 92.6MB

**Multi-stage builds** : Optimisation ~40% ✅

---

## 🧪 Tests

```bash
# Exécuter les tests
docker-compose exec backend pytest test_app.py -v

# Résultat: 14/14 PASSED ✅
```

Couverture:
- ✅ Health check & endpoints
- ✅ CRUD (Create, Read, Update, Delete)
- ✅ Gestion erreurs (400, 404, 500)
- ✅ Validation données

---

## 🛠️ Commandes Utiles

```bash
docker-compose ps              # État des services
docker-compose logs -f         # Logs temps réel
docker-compose restart         # Redémarrage
docker-compose down            # Arrêt complet
docker-compose exec backend pytest test_app.py -v  # Tests
```

---

## ☸️ Kubernetes

```bash
cd kubernetes
./deploy.sh

# Contient: Deployments (2 replicas), Services, ConfigMaps, Health checks
```

---

## ☁️ Azure + Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Crée:
- VM Ubuntu avec Docker/K3s pré-installé
- IP publique configurée
- Networking complet

---

## 🤖 Pipeline CI/CD

**Flux**: `git push` → Tests → Build Docker → Push → SSH Deploy → kubectl apply

**Secrets requis** (voir COMPTE_RENDU.md):
- `VM_HOST` - IP de la VM
- `VM_USERNAME` - User SSH
- `VM_SSH_KEY` - Clé privée SSH
- Registry credentials (Docker Hub / ACR)

---

## 📁 Structure

```
app-automation/
├── backend/              # Flask API + 14 tests
├── frontend/             # Nginx + HTML/CSS/JS
├── kubernetes/           # Manifests K8s complets
├── terraform/            # IaC Azure
├── .github/workflows/    # CI/CD pipeline
├── scripts/              # Setup/deploy scripts
├── docker-compose.yml    # Orchestration locale
├── README.md             # CE FICHIER (guide rapide)
└── COMPTE_RENDU.md       # Rapport complet avec preuves
```

---

## 📊 Statut

| Aspect | Statut |
|--------|--------|
| Containerisation | ✅ Complet |
| Docker Compose | ✅ Fonctionnel |
| Kubernetes | ✅ Prêt |
| Azure Terraform | ✅ IaC complet |
| Pipeline CI/CD | ✅ Structure |
| Tests | ✅ 14/14 PASS |
| Documentation | ✅ Complète |

---

## 📖 Documentation Complète

**→ Voir [COMPTE_RENDU.md](COMPTE_RENDU.md) pour:**
- ✅ Rapport détaillé du projet
- ✅ Preuves de fonctionnement
- ✅ Exemples requêtes/réponses API
- ✅ Résultats des tests complets
- ✅ Checklist exhaustive

---

## 🔧 Prérequis

- Docker & Docker Compose
- Git
- Terminal (PowerShell/Bash)

---

**Projet 100% fonctionnel et production-ready ! 🚀**

Pour plus de détails → [COMPTE_RENDU.md](COMPTE_RENDU.md)
