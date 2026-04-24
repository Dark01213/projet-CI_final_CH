# 🔐 SECRETS CONFIGURATION - GitHub Actions

## 📋 Tableau récapitulatif des Secrets

| Secret ID | Type | Description | Obligatoire | Exemple |
|-----------|------|-------------|-------------|---------|
| VM_HOST | Secret | Adresse IP VM Azure | ✅ OUI | `51.11.123.456` |
| VM_USERNAME | Secret | Utilisateur SSH | ✅ OUI | `azureuser` |
| VM_SSH_KEY | Secret | Clé privée SSH RSA | ✅ OUI | `-----BEGIN RSA...` |
| DOCKER_USERNAME | Secret | Username Docker Hub | ❌ NON | `votre_username` |
| DOCKER_PASSWORD | Secret | Token Docker Hub | ❌ NON | `dckr_pat_xxx` |
| GITHUB_TOKEN | Secret (auto) | Token GitHub Actions | ✅ AUTO | Automatique |
| APP_ENV | Variable | Environnement app | ✅ OUI | `production` |
| APP_ID | Variable | Identifiant app | ✅ OUI | `app-automation-prod` |

---

## 🔑 Configuration Détaillée par Secret

### 1️⃣ VM_HOST (Obligatoire)

```
📍 ID: VM_HOST
🔒 Type: Repository Secret
📝 Visibilité: Private
⏰ Rotation: Tous les 6 mois ou changement d'IP
```

**Où obtenir la valeur?**

Option 1 - Via Terraform:
```bash
cd terraform
terraform output -raw public_ip_address
# Output: 51.11.123.456
```

Option 2 - Via Azure Portal:
```
Azure → Machines virtuelles → app-automation-vm
→ Vue d'ensemble → Adresse IP publique
```

**Format accepté**:
```
✓ 51.11.123.456 (IPv4)
✓ 2001:0db8:85a3:0000:0000:8a2e:0370:7334 (IPv6)
✓ DNS si disponible
```

---

### 2️⃣ VM_USERNAME (Obligatoire)

```
📍 ID: VM_USERNAME
🔒 Type: Repository Secret
📝 Visibilité: Private
⏰ Rotation: Jamais (sauf changement utilisateur OS)
```

**Valeur recommandée**: `azureuser`

Cette valeur est définie dans `terraform/main.tf`:
```hcl
admin_username = "azureuser"
```

**Pourquoi un secret?**
- Évite de hardcoder le username
- Permet de le changer sans modifier la pipeline
- Maintient la séparation config/code

---

### 3️⃣ VM_SSH_KEY (Obligatoire ⚠️)

```
📍 ID: VM_SSH_KEY
🔒 Type: Repository Secret (CRITICAL)
📝 Visibilité: Private
⏰ Rotation: Tous les 90 jours OBLIGATOIRE
🚨 Sécurité: JAMAIS exposer, JAMAIS commiter
```

**Génération de la clé SSH**

```bash
# Étape 1: Générer la clé (si non existante)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Étape 2: Afficher la clé PRIVÉE
cat ~/.ssh/id_rsa

# Output:
# -----BEGIN RSA PRIVATE KEY-----
# MIIEowIBAAKCAQEA1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z
# ... [plusieurs lignes] ...
# -----END RSA PRIVATE KEY-----

# Étape 3: Copier INTÉGRALEMENT (en-têtes inclus)
# - Inclure: -----BEGIN RSA PRIVATE KEY-----
# - Inclure: -----END RSA PRIVATE KEY-----
# - Inclure toutes les lignes du milieu
```

**Ajouter la clé publique à la VM**

```bash
# 1. Copier la clé publique
cat ~/.ssh/id_rsa.pub

# 2. Sur la VM (via SSH manuel ou console Azure)
echo "$(cat ~/.ssh/id_rsa.pub)" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 3. Vérifier
ssh -i ~/.ssh/id_rsa azureuser@<VM_HOST> "echo 'SSH fonctionne!'"
```

**Format attendu dans le secret**:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA1a2b3c4d5e6f...
... (plusieurs lignes)
-----END RSA PRIVATE KEY-----
```

---

### 4️⃣ DOCKER_USERNAME (Optionnel)

```
📍 ID: DOCKER_USERNAME
🔒 Type: Repository Secret
📝 Visibilité: Private
⏰ Rotation: Tous les 6 mois
💡 Optionnel: Requis seulement si vous pushez sur Docker Hub
```

**Obtenir la valeur**:
```
Docker Hub → Compte → Identifiants → Username
```

---

### 5️⃣ DOCKER_PASSWORD (Optionnel)

```
📍 ID: DOCKER_PASSWORD
🔒 Type: Repository Secret (ACCESS TOKEN)
📝 Visibilité: Private
⏰ Rotation: Tous les 90 jours
💡 Optionnel: Token personal access, PAS le mot de passe!
```

**Créer un token Docker Hub**:
```
Docker Hub → Account → Security → New Access Token
- Name: github-actions-token
- Permissions: Read, Write, Delete
- Copier le token généré
```

---

## 🎯 Comment Configurer les Secrets sur GitHub

### Via l'interface GitHub

1. **Aller aux paramètres du repo**
   ```
   GitHub → Votre Repo → Settings
   ```

2. **Accéder aux secrets**
   ```
   Secrets and variables → Actions → New repository secret
   ```

3. **Ajouter chaque secret**

   ```
   Nom: VM_HOST
   Valeur: 51.11.123.456
   [Add secret]
   ```

4. **Vérifier les secrets ajoutés**
   ```
   Settings → Secrets → 5 secrets configurés
   ```

### Via GitHub CLI

```bash
# 1. Installer GitHub CLI
# https://cli.github.com

# 2. Authentifier
gh auth login

# 3. Ajouter les secrets
gh secret set VM_HOST --body "51.11.123.456"
gh secret set VM_USERNAME --body "azureuser"
gh secret set VM_SSH_KEY < ~/.ssh/id_rsa

# 4. Vérifier
gh secret list
```

---

## 📊 Tableau d'État des Secrets

```
┌─────────────────┬──────────┬────────────┬──────────────────────────┐
│ Secret ID       │ Status   │ Expire     │ Dernière modification    │
├─────────────────┼──────────┼────────────┼──────────────────────────┤
│ VM_HOST         │ ✅ OK    │ 2026-04-23 │ 2024-01-15 (90j)        │
│ VM_USERNAME     │ ✅ OK    │ ∞          │ 2023-06-01 (jamais)     │
│ VM_SSH_KEY      │ ✅ OK    │ 2026-07-22 │ 2024-04-23 (90j)        │
│ DOCKER_USERNAME │ ⚠️ MANQ  │ N/A        │ Jamais configuré        │
│ DOCKER_PASSWORD │ ⚠️ MANQ  │ N/A        │ Jamais configuré        │
│ GITHUB_TOKEN    │ ✅ AUTO  │ Par run    │ Automatique              │
└─────────────────┴──────────┴────────────┴──────────────────────────┘

Légende:
✅ OK    = Configuré et valide
✅ AUTO  = Généré automatiquement par GitHub
⚠️ MANQ  = Manquant (optionnel dans ce cas)
```

---

## 🔒 Sécurité des Secrets Configurés

### Masquage Automatique

GitHub masque automatiquement dans les logs:

```yaml
# Configuration
VM_HOST: "51.11.123.456"
VM_SSH_KEY: "-----BEGIN RSA PRIVATE KEY-----..."

# Dans les logs (affichage)
Deploying to: *** (VM_HOST masqué)
SSH key: *** (VM_SSH_KEY masqué)
```

### Auditer l'Utilisation des Secrets

```
Settings → Security → Secret scanning → Alerts
```

### Révoquer un Secret Compromis

1. **Supprimer le secret sur GitHub**
   ```
   Settings → Secrets → [Secret] → Delete
   ```

2. **Changer la valeur sur la VM/Docker**
   ```bash
   # Exemple pour SSH
   # Retirer l'ancienne clé de ~/.ssh/authorized_keys
   ```

3. **Ajouter le nouveau secret**
   ```
   Settings → Secrets → New repository secret
   ```

4. **Re-déployer**
   ```bash
   git push  # Déclenche la pipeline
   ```

---

## 🧪 Test des Secrets

### Vérifier que les secrets sont utilisés

```yaml
# Dans le workflow (.github/workflows/ci-cd.yml)
- name: Verify secrets
  run: |
    # SAFE: Affichera *** (masqué)
    echo "Testing VM_HOST: ${{ secrets.VM_HOST }}"
    
    # SAFE: Affichera *** (masqué)
    echo "Testing SSH Key: ${{ secrets.VM_SSH_KEY }}"
```

### Test de connectivité SSH

```bash
# Test manuel (avant de configurer dans GitHub)
ssh -i ~/.ssh/id_rsa azureuser@51.11.123.456 "whoami"

# Output attendu: azureuser
```

### Test de déploiement

```bash
# Déclencher manuellement la pipeline
git push origin main

# Vérifier dans: Actions → Workflow run
# Les logs doivent montrer: ✓ Deployment successful
```

---

## ⚠️ Erreurs Courantes

### Erreur 1: "SSH key invalid"

**Cause**: Clé mal formatée dans le secret

**Solution**:
```bash
# Vérifier le format
cat ~/.ssh/id_rsa | head -1
# Doit afficher: -----BEGIN RSA PRIVATE KEY-----

cat ~/.ssh/id_rsa | tail -1
# Doit afficher: -----END RSA PRIVATE KEY-----

# Si utilisation d'ed25519:
# La clé doit commencer par: -----BEGIN OPENSSH PRIVATE KEY-----
```

### Erreur 2: "Permission denied (publickey)"

**Cause**: Clé publique pas sur la VM

**Solution**:
```bash
# Sur la VM
cd ~/.ssh
cat authorized_keys | grep "<votre_clé_publique>"

# Si absent:
echo "$(cat ~/.ssh/id_rsa.pub)" >> ~/.ssh/authorized_keys
```

### Erreur 3: Secret not found

**Cause**: Mauvais nom du secret

**Solution**:
```yaml
# ❌ INCORRECT (majuscules)
key: ${{ secrets.vm_host }}

# ✅ CORRECT (exactement comme configuré)
key: ${{ secrets.VM_HOST }}
```

---

## 📅 Calendrier de Maintenance

```
Chaque 90 jours (Rotation recommandée):
├── Lundi: Générer nouvelle clé SSH
├── Mardi: Ajouter clé publique à la VM
├── Mercredi: Mettre à jour secret GitHub
├── Jeudi: Tester déploiement
├── Vendredi: Supprimer ancienne clé
└── Documentation: Mettre à jour log

Chaque mois:
├── Vérifier les logs d'accès SSH
├── Auditer les secrets inutilisés
└── Vérifier les alertes de sécurité

Chaque année:
├── Rotation complète de toutes les clés
├── Audit de sécurité complet
└── Mise à jour de la documentation
```

---

## 📞 Support et Documentation

- **GitHub Secrets**: https://docs.github.com/en/actions/security-guides/encrypted-secrets
- **SSH Keys**: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- **Security Best Practices**: https://owasp.org/www-project-web-security-testing-guide/

---

**Version**: 2.0.0  
**Sécurité**: ⭐⭐⭐ CRITIQUE  
**Dernière mise à jour**: 2024-04-23  
**Prochaine révision**: 2024-07-23 (90 jours)
