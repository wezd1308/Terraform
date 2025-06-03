variable "subscription_id" {
  description = "Id de la suscripción de Azure"
  type        = string
  default     = ""
}
variable "resource_group_name" {
  description = "WEZDRG"
  type        = string
  default     = "WEZDRG"
}


variable "storageaccount" {
  description = "Storage account"
  type        = string
  default     = "wezdsa"
}


variable "location" {
  description = "Ubicación de la máquina virtual"
  type        = string
  default     = "East US"
}

variable "file_share" {
  description = "Azure File Share"
  type        = string
  default     = "wezdafs"
}


variable "file_sync" {
  description = "Azure File Sync"
  type        = string
  default     = "wezdafsy"
}

variable "sync_group" {
  description = "Azure Sync Group"
  type        = string
  default     = "wezdassg"
}
