variable "create_public_ip" {
  type     = bool
  default  = false
  nullable = false
}

variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "location" {
  type     = string
  default  = "eastus"
  nullable = false
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}

variable "my_public_ip" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type    = string
  default = null
}

# variable "size" {
#   type     = string
#   default  = "Standard_F2"
#   nullable = false
# }

variable "size" {
  type    = string
  default = "Standard_A2_v2"

  validation {
    condition     = contains(["Standard_A1_v2", "Standard_A2_v2", "Standard_A4_v2"], var.size)
    error_message = "VM Size ${var.size} is not an approved size."
  }
}
