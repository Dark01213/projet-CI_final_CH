# 🔐 Configuration des Secrets GitHub Actions

## Vue d'ensemble

Ce fichier explique comment configurer les **secrets** (identifiants sensibles) pour la pipeline CI/CD de manière **sécurisée**.

> ⚠️ **CRITIQUE**: Lisez également [SECURITY_GUIDE.md](SECURITY_GUIDE.md) et [SECRETS_CONFIGURATION.md](SECRETS_CONFIGURATION.md) pour la sécurité complète.

---

## 🔑 Secrets Requis pour la Pipeline

### 1️⃣ VM_HOST (Obligatoire)

**Description**: Adresse IP publique de votre VM Azure

**ID du Secret**: `VM_HOST`

**Comment obtenir**:
```bash
# Option 1: Via Terraform
cd terraform
terraform output -raw public_ip_address
# Output: 51.11.123.456

# Option 2: Via Azure Portal
# Azure Subscription → Virtual machines → app-automation-vm
# → Overview → Public IP address
```

---

### 2️⃣ VM_USERNAME (Obligatoire)

**Description**: Nom d'utilisateur pour l'accès SSH

**ID du Secret**: `VM_USERNAME`

**Valeur recommandée**: `azureuser`

Cette valeur est définie dans `terraform/main.tf`.

---

### 3️⃣ VM_SSH_KEY (Obligatoire ⚠️ CRITIQUE)

**Description**: Clé SSH privée RSA pour l'authentification à la VM

**ID du Secret**: `VM_SSH_KEY`

#### Générer la Clé SSH

```bash
# Étape 1: Créer une paire de clés
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Étape 2: Afficher la clé PRIVÉE
cat ~/.ssh/id_rsa

# Output:
# -----BEGIN RSA PRIVATE KEY-----
# MIIEowIBAAKCAQEA1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4
# ... (plusieurs lignes) ...
# -----END RSA PRIVATE KEY-----
```

#### Ajouter le Secret GitHub

1. Aller à: **Settings → Secrets and variables → Actions**
2. Cliquer sur: **New repository secret**
3. **Name**: `VM_SSH_KEY`
4. **Value**: Coller la clé COMPLÈTE (en-têtes inclus)
5. Sauvegarder

#### Ajouter la Clé Publique à la VM

```bash
# Sur votre machine locale
cat ~/.ssh/id_rsa.pub

# Sur la VM (via SSH ou console Azure):
mkdir -p ~/.ssh
echo "$(cat ~/.ssh/id_rsa.pub)" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Tester la connexion
ssh -i ~/.ssh/id_rsa azureuser@<VM_IP> "whoami"
```

**Sécurité de la clé SSH**:
- ✅ Stockée de manière **chiffrée** dans GitHub
- ✅ **Jamais** exposée dans les logs
- ✅ Rotation: **TOUS LES 90 JOURS**
- ✅ **Jamais** commitée dans Git

---

## 📋 Configuration Complète

### Via GitHub UI

```
1. GitHub → Settings
2. Secrets and variables → Actions
3. New repository secret
4. Ajouter: VM_HOST, VM_USERNAME, VM_SSH_KEY
5. Valider
```

### Via GitHub CLI

```bash
gh auth login
gh secret set VM_HOST --body "51.11.123.456"
gh secret set VM_USERNAME --body "azureuser"
gh secret set VM_SSH_KEY < ~/.ssh/id_rsa
gh secret list
```

---

## 🌍 Variables d'Environnement Locales (.env)

### Créer le fichier .env

```bash
cp config/.env.example .env
nano .env
```

### Contenu recommandé

```env
FLASK_APP=app.py
FLASK_ENV=production
DEBUG=False
SECRET_KEY=your-secret-key-change-this
COMPOSE_PROJECT_NAME=app-automation
APP_ID=app-automation-prod
LOG_LEVEL=INFO
```

### Sécurité du .env

- ✅ Toujours dans `.gitignore`
- ✅ Jamais commiter
- ✅ Permissions: 600 (local)
- ✅ Partager via `.env.example` uniquement

---

## ✅ Checklist

### Configuration Initiale

- [ ] `VM_HOST` configuré dans GitHub Secrets
- [ ] `VM_USERNAME` configuré dans GitHub Secrets
- [ ] `VM_SSH_KEY` configuré dans GitHub Secrets
- [ ] Clé publique ajoutée à `~/.ssh/authorized_keys` sur la VM
- [ ] Test SSH manuel fonctionne
- [ ] `.env` créé et dans `.gitignore`
- [ ] Pipeline test réussie

### Maintenance (tous les 90 jours)

- [ ] Rotationner `VM_SSH_KEY`
- [ ] Tester la connexion SSH
- [ ] Vérifier les accès

---

## 📖 Ressources

- **SECURITY_GUIDE.md** - Guide de sécurité complet
- **SECRETS_CONFIGURATION.md** - Configuration détaillée avec IDs
- **GitHub Docs**: https://docs.github.com/en/actions/security-guides/encrypted-secrets

---

**Version**: 2.0.0 | **Sécurité**: ⭐⭐⭐ CRITIQUE
