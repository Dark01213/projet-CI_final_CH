environment = "production"
location    = "westeurope"

vm_size     = "Standard_B2s"
vm_name     = "vm-task-app-prod"

admin_username = "azureuser"

tags = {
  Project     = "TaskApp"
  Environment = "Production"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
}
