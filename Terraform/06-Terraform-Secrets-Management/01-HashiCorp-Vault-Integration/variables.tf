variable "vault_role_id" {
  description = "Role ID for the Terraform AppRole in Vault"
  type        = string
  sensitive   = true
}

variable "vault_secret_id" {
  description = "Secret ID for the Terraform AppRole in Vault"
  type        = string
  sensitive   = true
}