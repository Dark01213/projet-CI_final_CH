environment = "production"
location    = "swedencentral"

vm_size     = "Standard_B2s_v2"
vm_name     = "vm-task-app-prod"

admin_username = "azureuser"

tags = {
  Project     = "TaskApp"
  Environment = "Production"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
}
