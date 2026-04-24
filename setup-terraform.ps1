#!/usr/bin/env pwsh
# Script pour charger les identifiants Azure depuis .env.local et lancer Terraform
# Usage: .\setup-terraform.ps1 [plan|apply|destroy]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("plan", "apply", "destroy")]
    [string]$Command = "plan"
)

Write-Host "Configuration Terraform avec identifiants locaux..." -ForegroundColor Green
Write-Host ""

# Chemin du fichier .env.local
$envFile = Join-Path (Get-Location) ".env.local"

if (-not (Test-Path $envFile)) {
    Write-Host "Erreur: Le fichier .env.local n'existe pas !" -ForegroundColor Red
    Write-Host "Créez-le en copiant .env.example et en le remplissant avec vos vraies valeurs" -ForegroundColor Yellow
    exit 1
}

Write-Host "OK: Fichier .env.local trouvé" -ForegroundColor Green

# Lire le fichier .env.local et charger les variables
Write-Host "Chargement des variables d'environnement..." -ForegroundColor Cyan

$envContent = Get-Content $envFile | Where-Object { $_ -notmatch "^#" -and $_ -notmatch "^`$" }

# D'abord, trouve si on utilise CLI auth
$useCliAuth = "false"
foreach ($line in $envContent) {
    if ($line -match "^AZURE_USE_CLI_AUTH=(.+)`$") {
        $useCliAuth = $matches[1].Trim('"').Trim("'")
        break
    }
}

# Ensuite charge toutes les variables
foreach ($line in $envContent) {
    if ($line -match "^([A-Z_]+)=(.+)`$") {
        $varName = $matches[1]
        $varValue = $matches[2].Trim('"').Trim("'")

        # Ne pas charger ARM_CLIENT_ID et ARM_CLIENT_SECRET en mode CLI auth
        if ($useCliAuth -eq "true" -and ($varName -eq "ARM_CLIENT_ID" -or $varName -eq "ARM_CLIENT_SECRET")) {
            Write-Host "  SKIP: $varName (non utilisé en mode CLI auth)" -ForegroundColor Gray
            # S'assurer que la variable n'est pas définie
            [Environment]::SetEnvironmentVariable($varName, $null, "Process")
            continue
        }

        # Définis la variable d'environnement
        [Environment]::SetEnvironmentVariable($varName, $varValue, "Process")

        # Affiche la variable (masque le secret)
        if ($varName -like "*SECRET*" -or $varName -like "*PASSWORD*") {
            Write-Host "  OK: $varName = ****" -ForegroundColor Gray
        } else {
            Write-Host "  OK: $varName = $varValue" -ForegroundColor Gray
        }
    }
}

# En mode CLI auth, s'assurer que les variables de service principal ne sont pas définies
if ($useCliAuth -eq "true") {
    [Environment]::SetEnvironmentVariable("ARM_CLIENT_ID", $null, "Process")
    [Environment]::SetEnvironmentVariable("ARM_CLIENT_SECRET", $null, "Process")
    Write-Host "Nettoyage des variables de service principal pour mode CLI auth..." -ForegroundColor Gray
}

Write-Host ""

# Récupère le mode
$demoMode = [Environment]::GetEnvironmentVariable("TERRAFORM_DEMO_MODE", "Process")

if ($demoMode -eq "true") {
    Write-Host "Mode DEMO actif - syntaxe seulement, pas de vraie création" -ForegroundColor Yellow
} else {
    if ($useCliAuth -eq "true") {
        Write-Host "Mode Azure CLI Auth actif - vérification connexion Azure..." -ForegroundColor Green

        # Vérifier que Azure CLI est connecté
        $azPath = $null
        if (Get-Command az -ErrorAction SilentlyContinue) {
            $azPath = "az"
        } elseif (Test-Path 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd') {
            $azPath = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd'
        }

        if ($azPath) {
            try {
                $accountInfo = & $azPath account show --output json 2>$null | ConvertFrom-Json
                if ($accountInfo) {
                    Write-Host "OK: Connecté à Azure sous $($accountInfo.user.name)" -ForegroundColor Green
                    Write-Host "Subscription: $($accountInfo.name) ($($accountInfo.id))" -ForegroundColor Gray
                } else {
                    Write-Host "Erreur: Pas connecté à Azure. Exécutez: az login" -ForegroundColor Red
                    exit 1
                }
            } catch {
                Write-Host "Erreur: Impossible de vérifier la connexion Azure" -ForegroundColor Red
                exit 1
            }

            # Ajouter Azure CLI au PATH pour Terraform uniquement si un chemin absolu est utilisé
            if ($azPath -ne "az") {
                $azDir = Split-Path $azPath
                if ($env:PATH -notlike "*$azDir*") {
                    $env:PATH = "$azDir;$env:PATH"
                    Write-Host "Azure CLI ajouté au PATH pour Terraform" -ForegroundColor Gray
                }
            }
        } else {
            Write-Host "Erreur: Azure CLI n'est pas installé ou n'est pas accessible depuis le PATH" -ForegroundColor Red
            exit 1
        }
    }
}

# Navigation vers le dossier terraform
$terraformDir = Join-Path (Get-Location) "terraform"
if (-not (Test-Path $terraformDir)) {
    Write-Host "Erreur: Dossier terraform introuvable !" -ForegroundColor Red
    exit 1
}

Push-Location $terraformDir

# Vérifier que terraform est installé
$terraformExe = "terraform"
try {
    $null = & $terraformExe version 2>$null
} catch {
    Write-Host "Erreur: Terraform n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Exécuter terraform init si nécessaire
if (-not (Test-Path ".terraform")) {
    Write-Host "Initialisation de Terraform..." -ForegroundColor Cyan
    & $terraformExe init -input=false
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de l'initialisation Terraform" -ForegroundColor Red
        Pop-Location
        exit 1
    }
}

# Exécuter la commande demandée
Write-Host "Exécution de Terraform $Command..." -ForegroundColor Cyan
if ($Command -eq "apply") {
    & $terraformExe apply -auto-approve -input=false
} elseif ($Command -eq "destroy") {
    & $terraformExe destroy -auto-approve -input=false
} else {
    & $terraformExe plan -input=false
}

Write-Host ""
Write-Host "Configuration Terraform terminée !" -ForegroundColor Green

Pop-Location