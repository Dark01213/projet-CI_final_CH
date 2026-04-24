# 🔐 GUIDE SÉCURISÉ - Obtenir tes identifiants Azure pour Terraform

## ⚠️  AVERTISSEMENT DE SÉCURITÉ

**NE JAMAIS utiliser ton mot de passe personnel directement dans Terraform !**
Ton email `cedric.hu@efrei.net` et mot de passe `&Ce24=Hu07` sont pour te connecter à Azure Portal, pas pour Terraform.

## ✅ SOLUTION SÉCURISÉE : Service Principal

### Étape 1: Installer Azure CLI (si pas déjà fait)
```powershell
winget install -e --id Microsoft.AzureCLI
```

### Étape 2: Se connecter à Azure avec tes credentials personnels
```bash
az login
```
- Email: `cedric.hu@efrei.net`
- Mot de passe: `&Ce24=Hu07`

### Étape 3: Créer un Service Principal dédié à Terraform
```bash
# Remplace {TON_SUBSCRIPTION_ID} par ton ID de souscription Azure
az ad sp create-for-rbac --name "terraform-sp-projet" --role Contributor --scopes /subscriptions/{TON_SUBSCRIPTION_ID}
```

**Résultat attendu:**
```json
{
  "appId": "12345678-1234-1234-1234-123456789012",
  "displayName": "terraform-sp-projet",
  "password": "super-secret-password-generated-by-azure",
  "tenant": "87654321-4321-4321-4321-210987654321"
}
```

### Étape 4: Remplir `.env.local` avec les vraies valeurs
```bash
# Ouvre .env.local et remplace:
ARM_SUBSCRIPTION_ID="{TON_SUBSCRIPTION_ID}"
ARM_CLIENT_ID="{appId du résultat}"
ARM_CLIENT_SECRET="{password du résultat}"
ARM_TENANT_ID="{tenant du résultat}"
TERRAFORM_DEMO_MODE="false"
```

### Étape 5: Tester la configuration
```powershell
.\setup-terraform.ps1
```

## 🔍 Comment trouver ton Subscription ID

Si tu ne connais pas ton Subscription ID:

```bash
# Après az login
az account list --output table
```

## 🛡️ Sécurité Garantie

- ✅ **Service Principal** = Identifiants dédiés à Terraform (pas tes credentials personnels)
- ✅ **Rôles limités** = Seulement les permissions nécessaires (Contributor)
- ✅ **Expiration possible** = Peut être révoqué à tout moment
- ✅ **Audit possible** = Azure log toutes les actions du SP
- ✅ **Pas dans Git** = `.env.local` ignoré par Git

## 🚨 NE PAS FAIRE

❌ Ne pas mettre ton mot de passe personnel dans `.env.local`
❌ Ne pas utiliser ton compte principal pour Terraform
❌ Ne pas commiter `.env.local` sur GitHub

## 📞 Support

Si tu as des problèmes avec Azure CLI ou la création du Service Principal, je peux t'aider étape par étape.

---

**Résumé:** Utilise tes credentials personnels seulement pour `az login`, puis crée un Service Principal dédié pour Terraform. C'est la méthode sécurisée recommandée par Microsoft.
