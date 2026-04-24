# ✅ Production Deployment Checklist

## Phase 1: Préparation locale

- [ ] Code clonné et complet
- [ ] Tous les fichiers présents (22 fichiers)
- [ ] Docker et Docker Compose installés
- [ ] Application démarre avec `docker-compose up -d`
- [ ] Frontend accessible: http://localhost
- [ ] Backend accessible: http://localhost:5000
- [ ] Health check répond: http://localhost:5000/health
- [ ] Tests passent: `docker-compose exec backend pytest test_app.py -v`
- [ ] Logs vérifiés sans erreurs

## Phase 2: Configuration GitHub

- [ ] Repository GitHub créé
- [ ] Code pushé vers main branch
- [ ] Branch protection activée pour main
- [ ] GitHub Actions visible dans l'onglet Actions
- [ ] Workflow ci-cd.yml visible

## Phase 3: Configuration Azure

- [ ] Compte Azure créé et actif
- [ ] Azure CLI installée: `az login` réussit
- [ ] Souscription sélectionnée: `az account set --subscription <id>`
- [ ] SSH key générée: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa`
- [ ] SSH key publique créée: `cat ~/.ssh/id_rsa.pub`

## Phase 4: Déploiement Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

- [ ] Terraform initialisé sans erreurs
- [ ] Plan montre 7 resources à créer
- [ ] Apply complété avec succès
- [ ] Resource group créé
- [ ] VM créée
- [ ] Public IP assignée
- [ ] Outputs affichés:
  - [ ] public_ip_address
  - [ ] private_ip_address
  - [ ] resource_group_name
  - [ ] vm_id

## Phase 5: Vérification VM

```bash
ssh -i ~/.ssh/id_rsa azureuser@<PUBLIC_IP>
```

- [ ] SSH connection réussit
- [ ] Docker est installé: `docker --version`
- [ ] Docker Compose est installé: `docker-compose --version`
- [ ] K3s/Kubernetes est installé: `sudo kubectl get nodes`
- [ ] Projet clonné dans /opt/app-automation
- [ ] docker-compose.yml présent
- [ ] kubernetes/ folder présent

## Phase 6: Application locale sur VM

```bash
cd /opt/app-automation
docker-compose up -d
```

- [ ] Services démarrent
- [ ] Backend container running
- [ ] Frontend container running
- [ ] Frontend accessible via http://<PUBLIC_IP>
- [ ] Backend accessible via http://<PUBLIC_IP>:5000
- [ ] Health check répond

## Phase 7: Configuration GitHub Secrets

GitHub Repo > Settings > Secrets and variables > Actions

- [ ] VM_HOST secret créé = <PUBLIC_IP>
- [ ] VM_USERNAME secret créé = azureuser
- [ ] VM_SSH_KEY secret créé = contenu de ~/.ssh/id_rsa

**Important**: Vérifier que VM_SSH_KEY contient la clé PRIVÉE complète:
```
-----BEGIN RSA PRIVATE KEY-----
[content]
-----END RSA PRIVATE KEY-----
```

## Phase 8: Test du pipeline CI/CD

```bash
git push origin main
```

- [ ] GitHub Actions workflow déclenché
- [ ] Test job complet:
  - [ ] Dépendances installées
  - [ ] Tests passent (7/7)
  - [ ] Coverage > 80%
- [ ] Build job complet:
  - [ ] Backend image built
  - [ ] Frontend image built
  - [ ] Images pushed (si main branch)
- [ ] Deploy job complet:
  - [ ] SSH connection établie
  - [ ] Code pulled
  - [ ] docker-compose updated
  - [ ] Services restarted
- [ ] Health check job complet:
  - [ ] /health endpoint répond
  - [ ] Status = "healthy"

## Phase 9: Déploiement Kubernetes

Sur la VM:
```bash
sudo bash kubernetes/deploy.sh
```

- [ ] ConfigMap créé
- [ ] Backend deployment créé
- [ ] Frontend deployment créé
- [ ] Services créés
- [ ] Pods running:
  - [ ] 2 backend pods
  - [ ] 2 frontend pods
- [ ] Services available:
  - [ ] backend-service (ClusterIP)
  - [ ] frontend-service (NodePort:30080)

Vérifications:
```bash
sudo kubectl get deployments
sudo kubectl get services
sudo kubectl get pods
sudo kubectl get events
```

- [ ] Tous les deployments READY (2/2)
- [ ] Tous les pods Running
- [ ] Pas d'erreurs dans les events
- [ ] Frontend accessible: http://<PUBLIC_IP>:30080

## Phase 10: Test complet

### Tests d'application

```bash
# Frontend
curl -s http://<PUBLIC_IP>:30080 | grep "Task Management"
```
- [ ] Retourne le HTML de l'application

```bash
# Backend health
curl -s http://<PUBLIC_IP>:5000/health | python -m json.tool
```
- [ ] Response: `{"status": "healthy"}`

```bash
# API test
curl -s http://<PUBLIC_IP>:5000/api/tasks | python -m json.tool
```
- [ ] Response: `[]` (empty array)

### Créer une tâche

```bash
curl -X POST http://<PUBLIC_IP>:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test task", "description": "Test"}'
```
- [ ] Response: task created (201)
- [ ] Task appears in GET /api/tasks

### Test frontend

Via navigateur:
- [ ] Aller à http://<PUBLIC_IP>:30080
- [ ] Page charge correctement
- [ ] Status indicator = "Connected to API"
- [ ] Créer une tâche depuis l'interface
- [ ] Tâche apparait dans la liste
- [ ] Tâche peut être complétée
- [ ] Tâche peut être supprimée

## Phase 11: Monitoring et logs

```bash
# Docker logs on VM
docker-compose logs -f

# Kubernetes logs
sudo kubectl logs -f deployment/backend-deployment

# Events
sudo kubectl get events

# Resource usage
sudo kubectl top pods
sudo kubectl top nodes
```

- [ ] Pas d'erreurs dans les logs
- [ ] Memory usage raisonnable
- [ ] CPU usage raisonnable
- [ ] Health checks passent régulièrement

## Phase 12: Maintenance

- [ ] Sauvegarder clés SSH de manière sécurisée
- [ ] Documenter l'IP publique
- [ ] Setup alertes (si monitoring)
- [ ] Planifier mises à jour
- [ ] Tester rollback procedures
- [ ] Vérifier backups

## Phase 13: Documentation

- [ ] README complété avec IP réelle
- [ ] SECRETS_SETUP.md reviewed
- [ ] Architecture documentée
- [ ] Contacts et responsables listés
- [ ] Procédures de maintenance docum

entées

## Phase 14: Sécurité finale

- [ ] Secrets jamais en clair dans logs
- [ ] SSH key sécurisée
- [ ] NSG rules correctes
- [ ] Updates de sécurité appliquées
- [ ] Certificats SSL/TLS envisagés

## 🎉 Déploiement complet!

Si tous les checkpoints sont cochés:

✅ Application développée et testée
✅ Infrastructure provisionnée
✅ Pipeline CI/CD automatisé
✅ Déploiement sans erreur
✅ Application accessible
✅ Monitoring en place
✅ Documentation complète

**Status: Production Ready**

---

## 📞 Troubleshooting rapide

### Problème: SSH connection refused
```
Solution: Vérifier les règles NSG - port 22 doit être autorisé
```

### Problème: Container won't start
```
Solution: Vérifier docker-compose logs -f
         Vérifier que les ports sont disponibles
```

### Problème: Kubernetes pods not ready
```
Solution: kubectl describe pod <pod-name>
         kubectl logs <pod-name>
         Vérifier les resources (requests/limits)
```

### Problème: Pipeline fails
```
Solution: Vérifier les GitHub Actions logs
         Vérifier les secrets configurés
         Tester localement d'abord
```

### Problème: Application can't connect to backend
```
Solution: Vérifier la variable REACT_APP_API_URL
         Vérifier la configuration Nginx
         Vérifier les règles NSG (port 5000)
```

## 📊 Status Dashboard

Créer un dashboard pour suivre:
- [ ] Application availability
- [ ] Container health
- [ ] CPU/Memory usage
- [ ] API response times
- [ ] Deployment status
- [ ] Pipeline status

## 🔄 Procédure de mise à jour

Pour une nouvelle version:
```
1. Modifier le code
2. git add / commit / push origin main
3. Pipeline démarre automatiquement
4. Tests exécutés
5. Build Docker
6. Déploiement SSH
7. Kubernetes update
8. Health checks
9. ✅ Nouvelle version live
```

**Temps total: ~10 minutes (automatisé)**

---

**Checklist version**: 1.0
**Dernière mise à jour**: 2024
**Statut**: Complète
