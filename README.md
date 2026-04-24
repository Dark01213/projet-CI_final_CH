# Projet CI/CD Azure + Terraform

## Objectif
Ce projet automatise le déploiement d'une application web conteneurisée avec Docker, Kubernetes et Terraform sur Azure.

## Prérequis
- Docker
- Docker Compose
- Terraform
- Azure CLI
- kubectl
- PowerShell (pour `setup-terraform.ps1` sur Windows)

## Préparation
1. Copier le modèle de variables d'environnement:
   ```powershell
   cp .env.example .env.local
   ```
2. Remplir `.env.local` avec votre `ARM_SUBSCRIPTION_ID` et `ARM_TENANT_ID`.
3. Se connecter à Azure:
   ```powershell
   az login
   ```

## Déploiement Terraform
- Planifier:
  ```powershell
  pwsh .\setup-terraform.ps1 plan
  ```
- Appliquer:
  ```powershell
  pwsh .\setup-terraform.ps1 apply
  ```
- Détruire:
  ```powershell
  pwsh .\setup-terraform.ps1 destroy
  ```

## Déploiement alternatif avec le script rapide
Vous pouvez aussi utiliser le script racine `quickstart.sh` depuis un terminal Bash:
```bash
bash quickstart.sh
```

## Commandes utiles
- Démarrer localement:
  ```bash
docker-compose up -d
```
- Arrêter:
  ```bash
docker-compose down
```
- Détruire l'infrastructure Azure:
  ```powershell
  pwsh .\setup-terraform.ps1 destroy
```

## Notes
- Le fichier `.env.local` est exclu du dépôt par `.gitignore`.
- Utilisez `az login` avant d'exécuter le script Terraform.
