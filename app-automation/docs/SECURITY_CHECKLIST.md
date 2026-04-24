# ✅ Checklist de Sécurité - Pipeline CI/CD

## 🎯 Avant le Déploiement

### Secrets GitHub Actions
- [ ] **VM_HOST** configuré
  - [ ] ID: `VM_HOST`
  - [ ] Valeur: IP publique de la VM
  - [ ] Format: `51.11.123.456` ou DNS
  - [ ] Vérification: `terraform output -raw public_ip_address`

- [ ] **VM_USERNAME** configuré
  - [ ] ID: `VM_USERNAME`
  - [ ] Valeur: `azureuser`
  - [ ] Stocké comme secret GitHub

- [ ] **VM_SSH_KEY** configuré
  - [ ] ID: `VM_SSH_KEY`
  - [ ] Valeur: Clé privée RSA complète
  - [ ] Inclut: `-----BEGIN RSA PRIVATE KEY-----`
  - [ ] Inclut: `-----END RSA PRIVATE KEY-----`
  - [ ] Taille: 4096 bits minimum
  - [ ] Généré avec: `ssh-keygen -t rsa -b 4096`

### Configuration SSH sur la VM
- [ ] Clé publique ajoutée à `~/.ssh/authorized_keys`
- [ ] Permissions correctes: `chmod 600 ~/.ssh/authorized_keys`
- [ ] Dossier SSH correct: `chmod 700 ~/.ssh`
- [ ] Test manuel réussi: `ssh -i ~/.ssh/id_rsa azureuser@<VM_IP>`

### Fichiers de Configuration Locaux
- [ ] `.env` créé depuis `.env.example`
- [ ] `.env` contient les valeurs correctes
- [ ] `.env` est dans `.gitignore`
- [ ] `.env` n'a jamais été commité
- [ ] Permissions: `chmod 600 .env`

### Vérifications Git
- [ ] Aucun secret en clair dans le code
- [ ] `.gitignore` contient:
  - [ ] `.env`
  - [ ] `.env.local`
  - [ ] `*.pem`
  - [ ] `*.key`
  - [ ] `credentials.json`
- [ ] Pas de clés SSH dans le repo

### Pipeline Workflow
- [ ] Validations de secrets présentes
- [ ] Masquage automatique vérifié
- [ ] Permissions minimales définies
- [ ] Timeouts configurés correctement

---

## 🚀 Premier Déploiement

### Avant `git push`
- [ ] Tous les secrets GitHub configurés
- [ ] Tests locaux réussis: `docker-compose up -d`
- [ ] Tests locaux réussis: `docker-compose logs`
- [ ] Application accessible: `http://localhost`
- [ ] Health check accessible: `http://localhost:5000/health`

### Après `git push origin main`
- [ ] Workflow déclenché automatiquement
- [ ] Étape 1 (Tests) réussie: ✓
- [ ] Étape 2 (Build) réussie: ✓
- [ ] Étape 3 (Deploy) réussie: ✓
- [ ] Étape 4 (Health Check) réussie: ✓
- [ ] Logs accessibles et sans erreurs

### Vérification Post-Déploiement
- [ ] Application accessible sur VM: `http://<VM_IP>`
- [ ] Health check OK: `http://<VM_IP>:5000/health`
- [ ] Docker Compose running: SSH → `docker-compose ps`
- [ ] Kubernetes pods running: SSH → `kubectl get pods`
- [ ] Logs sans erreurs: SSH → `docker-compose logs`

---

## 🔒 Sécurité des Logs

### Vérification des Logs
- [ ] Les secrets ne s'affichent pas dans les logs
- [ ] `VM_HOST` affiché comme: `***`
- [ ] `VM_USERNAME` affiché comme: `***`
- [ ] `VM_SSH_KEY` affiché comme: `***`
- [ ] Aucune clé privée visible
- [ ] Aucun mot de passe visible
- [ ] Aucun token API visible

### Audit des Logs
```bash
# Vérifier les logs ne contiennent pas les secrets
grep -r "ssh-rsa" logs/  # ❌ Ne doit rien trouver
grep -r "BEGIN RSA" logs/  # ❌ Ne doit rien trouver
grep -r "51.11.123.456" logs/  # ❌ Ne doit rien trouver
```

---

## 🛡️ Sécurité Hebdomadaire

### Chaque semaine
- [ ] Vérifier les erreurs SSH dans les logs
- [ ] Vérifier les accès non autorisés
- [ ] Vérifier les changements Git non autorisés
- [ ] Vérifier les alertes de sécurité GitHub

### Actions en cas d'alerte
- [ ] Identifier la source
- [ ] Réviser les secrets
- [ ] Rotationner si compromis
- [ ] Tester les nouveaux secrets

---

## 🔄 Rotation des Secrets (Tous les 90 jours)

### Jour 1: Préparation
- [ ] Générer nouvelle clé SSH: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_new`
- [ ] Noter la date de rotation
- [ ] Préparer le plan de rollback

### Jour 2: Déploiement
- [ ] Ajouter nouvelle clé publique à la VM
- [ ] Vérifier accès avec nouvelle clé: `ssh -i ~/.ssh/id_rsa_new azureuser@<VM_IP>`
- [ ] Mettre à jour secret GitHub: `VM_SSH_KEY`

### Jour 3: Test
- [ ] Déclencher pipeline test: `git push`
- [ ] Vérifier déploiement réussi
- [ ] Vérifier application accessible
- [ ] Vérifier health checks OK

### Jour 4: Nettoyage
- [ ] Supprimer ancienne clé de `~/.ssh/authorized_keys`
- [ ] Supprimer ancien fichier `~/.ssh/id_rsa`
- [ ] Documenter la rotation
- [ ] Marquer calendrier pour prochaine rotation

### Jour 5: Finalisation
- [ ] Vérifier pas d'accès ancienne clé
- [ ] Vérifier logs sans erreurs
- [ ] Mettre à jour documentation
- [ ] Notifier l'équipe

---

## 📋 Sécurité des Permissions

### Permissions Git
- [ ] Repository: Private
- [ ] Main branch: Protected branch
- [ ] PRs requises: Oui
- [ ] Approvals requises: 1 minimum
- [ ] Status checks: Obligatoires
- [ ] Dismiss stale reviews: Activé
- [ ] Require code owner reviews: Activé

### Permissions Secrets
- [ ] Secrets limités au workflow CI/CD
- [ ] Secrets non visibles dans les logs
- [ ] Audit trail disponible
- [ ] Accès restreint aux admins

### Permissions VM SSH
- [ ] SSH key: 600 `~/.ssh/id_rsa`
- [ ] SSH folder: 700 `~/.ssh/`
- [ ] authorized_keys: 600
- [ ] Pas d'accès root par défaut
- [ ] Sudo configuré correctement

---

## 🔐 Politique de Secrets

### Règles strictes
- [ ] **Jamais** hardcoder les secrets
- [ ] **Jamais** passer secrets en arguments
- [ ] **Jamais** commiter de clés privées
- [ ] **Jamais** partager secrets sur Slack/Email
- [ ] **Toujours** utiliser GitHub Secrets
- [ ] **Toujours** rotationner régulièrement
- [ ] **Toujours** auditer l'accès

### En cas de compromission
- [ ] Révoquer immédiatement le secret
- [ ] Générer nouveau secret
- [ ] Mettre à jour GitHub
- [ ] Mettre à jour VM
- [ ] Redéployer
- [ ] Vérifier les logs compromis
- [ ] Documenter l'incident

---

## 📊 Dashboard de Sécurité

### Tableau de suivi

```
Secret ID        | Status | Expire     | Vérification | Rotation
─────────────────┼────────┼────────────┼──────────────┼──────────
VM_HOST          | ✅ OK  | 2026-06-23 | ✓ IP valide  | 6 mois
VM_USERNAME      | ✅ OK  | ∞          | ✓ SSH OK     | Jamais*
VM_SSH_KEY       | ✅ OK  | 2026-07-23 | ✓ 4096 bits  | 90 jours
GITHUB_TOKEN     | ✅ OK  | Par run    | ✓ Auto       | Auto
─────────────────┴────────┴────────────┴──────────────┴──────────

Legend:
✅ OK   = Sécurisé et fonctionnel
⚠️ WARN = À vérifier bientôt
❌ FAIL = Action requise immédiatement
* = Sauf changement utilisateur OS
```

---

## 🎓 Ressources de Sécurité

### Documentation Interne
- [SECURITY_GUIDE.md](SECURITY_GUIDE.md) - Guide complet
- [SECRETS_CONFIGURATION.md](SECRETS_CONFIGURATION.md) - Configuration détaillée
- [SECRETS_SETUP.md](SECRETS_SETUP.md) - Setup rapide
- [COMMANDS_REFERENCE.md](COMMANDS_REFERENCE.md) - Commandes

### Documentation Externe
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [OWASP Security](https://owasp.org/www-project-web-security-testing-guide/)
- [CIS Controls](https://www.cisecurity.org/controls/)

---

## 📞 Support Sécurité

### En cas de problème
1. **Consulter**: SECURITY_GUIDE.md
2. **Consulter**: SECRETS_CONFIGURATION.md
3. **Consulter**: Logs GitHub Actions
4. **Tester**: SSH manuel `ssh -i ~/.ssh/id_rsa azureuser@<VM_IP>`
5. **Documenter**: Décrire le problème
6. **Résoudre**: Appliquer les étapes correctives

---

**Version**: 1.0.0  
**Sécurité**: ⭐⭐⭐ CRITIQUE  
**Dernière mise à jour**: 2024-04-23  
**Prochaine revue**: 2024-07-23 (90 jours)
