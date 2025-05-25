variable "subscription_id" {
  description = "d3b3c8cb-2e1d-4cc0-b02f-ae2272a66ec1"
  type        = string
  default     = ""
}
variable "resource_group_name" {
  description = "TESTRG"
  type        = string
  default     = "RGWEZDLAB"
}

variable "location" {
  description = "Ubicación del RG"
  type        = string
  default     = "East US"
  
  
}

variable "vnet" {
  description = "Virtual Network"
  type        = string
  default     = "VNETLABWZ"
  
  
}

variable "vnet_GW" {
  description = "Virtual Network GW"
  type        = string
  default     = "VNGWEZD"
  
  
}