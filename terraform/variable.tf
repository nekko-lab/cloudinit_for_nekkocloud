# PROXMOX PROVIDER CONFIGURATION
variable "PM_USER" {
  description = "The Proxmox user"
  type        = string
  default     = ""
}


variable "PM_PASS" {
  description = "The Proxmox login password"
  type        = string
  default     = ""
}


variable "PM_API_TOKEN_ID" {
  description = "The Proxmox API Token ID"
  type        = string
  default     = ""
}


variable "PM_API_TOKEN_SECRET" {
  description = "The Proxmox API Token Secret"
  type        = string
  default     = ""
}


variable "PM_TLS_INSECURE" {
  description = "The Proxmox TLS insecure flag"
  type        = bool
  default     = "true"
}


variable "PM_DEBUG" {
  description = "The Proxmox debug flag"
  type        = bool
  default     = "true"
}


variable "PM_LOG_ENABLE" {
  description = "The Proxmox log enable flag"
  type        = bool
  default     = "true"
}


variable "PM_LOG_LEVEL" {
  description = "The Proxmox log level"
  type        = string
  default     = "debug"
}


variable "PM_LOG_FILE" {
  description = "The Proxmox log file"
  type        = string
  default     = "terraform-plugin-proxmox.log"
}


variable "NC_REGION" {
  description = "The NekkoCloud region"
  type        = string
  default     = ""  # Set Proxmox region: mk, ur, tu
}


variable "NC_REGION_IP" {
  description = "The NekkoCloud region IPv6 address"
  type        = map(string)
  default     = {
    "mk" = "fd12:e644:6d9d:00::",
    "ur" = "fd12:e644:6d9d:01::",
    "tu" = "fd12:e644:6d9d:02::"
  }
}


# VM CONFIGURATION
variable "vm_name" {
  description = "The name of the VM"
  type        = string
  default     = ""
}


variable "username" {
  description = "The username to assign to the VM"
  type        = string
  default     = ""
}


variable "password" {
  description = "The password to assign to the VM"
  type        = string
  default     = ""
}


variable "public_key" {
  description = "The public key to be used for SSH"
  type        = string
  default     = ""
}
