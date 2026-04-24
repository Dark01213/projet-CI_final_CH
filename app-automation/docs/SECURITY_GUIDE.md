# 🔐 Guide de Sécurité - Pipeline CI/CD

## 📋 Vue d'ensemble

Ce guide explique comment configurer la sécurité complète du pipeline CI/CD avec les secrets, identifiants et variables d'environnement.

---

## 🔑 Secrets GitHub Actions Requis

### Configuration des Secrets

Allez à: **Settings > Secrets and variables > Actions > New repository secret**

#### 1. VM_HOST (Identifiant VM)
```
Name: VM_HOST
Type: Secret
Value: <IP_PUBLIQUE_DE_LA_VM>
Example: 51.11.123.456
```
**Description**: Adresse IP publique de votre VM Azure  
**Obtenir la valeur**:
```bash
# Après terraform apply
terraform output -raw public_ip_address

# Ou dans Azure Portal
# VM > Overview > Public IP address
```

#### 2. VM_USERNAME (Identifiant Utilisateur)
```
Name: VM_USERNAME
Type: Secret
Value: azureuser
```
**Description**: Nom d'utilisateur pour SSH (défini dans Terraform)  
**Valeur fixe**: `azureuser`

#### 3. VM_SSH_KEY (Clé SSH Privée)
```
Name: VM_SSH_KEY
Type: Secret
Value: <CONTENU_COMPLET_DE_VOTRE_CLÉ_PRIVÉE>
```
**Description**: Clé SSH privée pour l'authentification  
**Comment générer**:

```bash
# 1. Générer une clé SSH (si non existante)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# 2. Copier la clé PRIVÉE
cat ~/.ssh/id_rsa

# 3. Coller le contenu complet dans le secret GitHub
# ⚠️ INCLURE: -----BEGIN RSA PRIVATE KEY----- et -----END RSA PRIVATE KEY-----
```

#### 4. DOCKER_USERNAME (Optional - Docker Hub)
```
Name: DOCKER_USERNAME
Type: Secret
Value: <VOTRE_USERNAME_DOCKERHUB>
```

#### 5. DOCKER_PASSWORD (Optional - Docker Hub)
```
Name: DOCKER_PASSWORD
Type: Secret
Value: <VOTRE_TOKEN_DOCKERHUB>
```

---

## 🔒 Sécurité de la Pipeline

### Validations de Sécurité

Le workflow inclut des validations automatiques:

```yaml
- name: Validate secrets
  run: |
    if [[ -z "${{ secrets.VM_HOST }}" ]]; then
      echo "ERROR: VM_HOST secret is not configured"
      exit 1
    fi
```

**Ces validations**:
- ✅ Vérifient que tous les secrets sont configurés
- ✅ Arrêtent le pipeline si un secret manque
- ✅ Évitent les déploiements incomplets

### Masquage Automatique des Secrets

GitHub Actions masque automatiquement:
- ✅ Tous les secrets dans les logs
- ✅ Les variables d'environnement sensibles
- ✅ Les données de la pipeline

**Exemple de log sécurisé**:
```
Deployment to: ***
Username: ***
SSH Key: ***
```

---

## 🆔 Identifiants d'Application

### APP_ID (Identifiant Unique)

```yaml
env:
  APP_ID: app-automation-prod
```

**Utilisé pour**:
- Identification unique de l'application
- Logs d'audit
- Traçabilité des déploiements

### Build Artifacts Identifiants

Chaque build reçoit des identifiants uniques:

```
Backend image: ghcr.io/username/app-automation/backend:main
Frontend image: ghcr.io/username/app-automation/frontend:main
Deployment ID: app-automation-prod-1681234567
```

---

## 📝 Variables d'Environnement (.env)

### Fichier .env Local

```bash
# 1. Copier le template
cp config/.env.example .env

# 2. Modifier avec vos valeurs
nano .env
```

### Contenu recommandé pour .env

```env
# Application
FLASK_APP=app.py
FLASK_ENV=production
DEBUG=False
SECRET_KEY=<CLEF_SECRÈTE_ALÉATOIRE>

# Database (si applicable)
DATABASE_URL=postgresql://user:password@db:5432/appdb

# Docker
COMPOSE_PROJECT_NAME=app-automation

# API
API_TIMEOUT=30
API_MAX_RETRIES=3

# Kubernetes
KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Logging
LOG_LEVEL=INFO
```

### Sécurité du .env

⚠️ **IMPORTANT**: 
- ✅ Ajouter `.env` à `.gitignore` (déjà fait)
- ✅ Jamais commiter de fichier `.env`
- ✅ Jamais partager vos secrets
- ✅ Utiliser des secrets GitHub Actions en production

### .gitignore (Vérification)

```gitignore
# Environment variables
.env
.env.local
.env.*.local

# SSH Keys
*.pem
*.key
!*.pub

# Credentials
credentials.json
secrets.json
```

---

## 🔐 Gestion des Secrets en Production

### Secrets GitHub Actions

Utilisé par la pipeline CI/CD:

```yaml
- name: Deploy to VM
  with:
    host: ${{ secrets.VM_HOST }}           # Masqué
    username: ${{ secrets.VM_USERNAME }}   # Masqué
    key: ${{ secrets.VM_SSH_KEY }}        # Masqué
```

**Avantages**:
- ✅ Jamais exposés dans les logs
- ✅ Chiffrés par GitHub
- ✅ Accessibles uniquement par le workflow autorisé
- ✅ Audit trail automatique

### ConfigMaps Kubernetes

Pour les variables non-sensibles:

```yaml
# kubernetes/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  ENVIRONMENT: production
  LOG_LEVEL: INFO
  API_TIMEOUT: "30"
```

### Secrets Kubernetes

Pour les données sensibles:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:
  DATABASE_PASSWORD: <PASSWORD>
  API_KEY: <KEY>
```

---

## 📊 Pipeline de Déploiement Sécurisé

### Flux de Sécurité

```
1. Push sur main branch
        ↓
2. ✅ Validation des secrets (avant le déploiement)
        ↓
3. 🧪 Tests unitaires (s'arrête si tests échouent)
        ↓
4. 🏗️  Build Docker (avec validation)
        ↓
5. 🔐 Login Container Registry (secrets masqués)
        ↓
6. 📦 Push images (versionnées automatiquement)
        ↓
7. 🚀 Déploiement SSH (secrets chiffrés)
        ↓
8. ☸️  Update Kubernetes
        ↓
9. 🏥 Health checks
        ↓
10. 📊 Rapport de déploiement
```

---

## 🔍 Audit et Monitoring

### Logs de la Pipeline

Les logs incluent (sans exposer les secrets):

```
✓ Étape validée
✓ Tests passés
✓ Images construites
✓ Déploiement réussi
✓ Health checks OK
```

### Vérifier les Secrets Utilisés

GitHub Actions affiche:
- ✅ Date et heure du déploiement
- ✅ Qui a déclenché la pipeline
- ✅ Application ID déployée
- ✅ Statut final

### Accéder aux Logs

**GitHub**:
```
Actions > Workflow run > Logs
```

---

## 🚨 Bonnes Pratiques de Sécurité

### ✅ À FAIRE

1. **Secrets GitHub**
   - ✓ Utiliser des secrets pour les données sensibles
   - ✓ Rotationner les clés régulièrement
   - ✓ Utiliser des clés SSH avec passphrase

2. **Code**
   - ✓ Jamais commiter de secrets
   - ✓ Utiliser .gitignore correctement
   - ✓ Utiliser des variables d'environnement

3. **Pipeline**
   - ✓ Activer les validations de secrets
   - ✓ Arrêter la pipeline si les tests échouent
   - ✓ Auditer les logs de déploiement

### ❌ À ÉVITER

1. **Secrets en clair**
   - ✗ Ne pas mettre de secrets dans le code
   - ✗ Ne pas les passer en paramètres visibles
   - ✗ Ne pas les afficher dans les logs

2. **Gestion des clés**
   - ✗ Ne pas utiliser la même clé partout
   - ✗ Ne pas partager les clés SSH
   - ✗ Ne pas laisser les clés dans l'historique Git

3. **Permissions**
   - ✗ Ne pas donner d'accès à toutes les branches
   - ✗ Ne pas permettre les déploiements manuels sans approbation
   - ✗ Ne pas réutiliser les mêmes secrets

---

## 🔄 Rotation des Secrets

### Quand rotationner

- ✅ Tous les 90 jours (bonne pratique)
- ✅ Après chaque déploiement sensible
- ✅ Si vous suspectez une compromission
- ✅ Après un changement de personnel

### Comment rotationner

1. **Générer une nouvelle clé**
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_new
   ```

2. **Mettre à jour la VM**
   ```bash
   # Sur la VM
   cat ~/.ssh/id_rsa_new.pub >> ~/.ssh/authorized_keys
   ```

3. **Mettre à jour le secret GitHub**
   - Aller à Settings > Secrets > VM_SSH_KEY
   - Mettre à jour avec la nouvelle clé

4. **Tester le déploiement**
   ```bash
   git push  # Déclenche la pipeline
   ```

5. **Supprimer l'ancienne clé**
   ```bash
   # Sur la VM
   # Retirer l'ancienne clé de ~/.ssh/authorized_keys
   ```

---

## 🔒 Checklist de Sécurité

### Avant le premier déploiement

- [ ] Tous les secrets GitHub sont configurés
- [ ] VM_HOST est correct
- [ ] VM_SSH_KEY est complète (include les en-têtes)
- [ ] .env est dans .gitignore
- [ ] Aucun secret n'est dans le code
- [ ] Les permissions Git sont restrictives
- [ ] SSH utilise RSA 4096-bit

### Après chaque déploiement

- [ ] Health checks passent
- [ ] Logs ne contiennent pas de secrets
- [ ] Logs contiennent l'App ID
- [ ] Pipeline s'est complétée sans erreurs
- [ ] Application est accessible

### Maintenance régulière

- [ ] Vérifier les logs d'accès SSH
- [ ] Rotationner les secrets tous les 90 jours
- [ ] Mettre à jour les dépendances
- [ ] Vérifier les alertes de sécurité
- [ ] Auditer les accès GitHub

---

## 🆘 Dépannage Sécurité

### Erreur: "SSH key is invalid"

```bash
# Vérifier le format de la clé
# Doit commencer par: -----BEGIN RSA PRIVATE KEY-----
# Doit finir par: -----END RSA PRIVATE KEY-----

# Vérifier les permissions sur la VM
ssh-keygen -l -f ~/.ssh/id_rsa.pub
```

### Erreur: "Permission denied (publickey)"

```bash
# Vérifier que la clé publique est sur la VM
cat ~/.ssh/authorized_keys | grep "$(cat ~/.ssh/id_rsa.pub)"

# Si absent, ajouter:
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Secret ne s'affiche pas dans les logs

C'est normal! GitHub masque les secrets. Utilisez:
```bash
# Dans le workflow
echo "Debug: ${{ secrets.MY_SECRET }}" # Affichera: ***
```

---

## 📞 Support

Pour plus d'informations:
- GitHub Secrets: https://docs.github.com/en/actions/security-guides/encrypted-secrets
- SSH Keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Security Best Practices: https://docs.github.com/en/code-security

---

**Version**: 1.0.0  
**Dernière mise à jour**: 2024  
**Priorité**: ⭐⭐⭐ CRITIQUE
