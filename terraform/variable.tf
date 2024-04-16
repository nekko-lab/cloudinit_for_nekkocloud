# PROXMOX PROVIDER CONFIGURATION
variable "PM_USER" {
    description = "The Proxmox user"
    type = string
    default = ""
}


variable "PM_PASS" {
    description = "The Proxmox login password"
    type = string
    default = ""
}


variable "PM_API_TOKEN_ID" {
    description = "The Proxmox API Token ID"
    type = string
    default = ""
}


variable "PM_API_TOKEN_SECRET" {
    description = "The Proxmox API Token Secret"
    type = string
    default = ""
}


variable "PM_TLS_INSECURE" {
    description = "The Proxmox TLS insecure flag"
    type = bool
    default = "true"
}


variable "PM_DEBUG" {
    description = "The Proxmox debug flag"
    type = bool
    default = "true"
}


variable "PM_LOG_ENABLE" {
    description = "The Proxmox log enable flag"
    type = bool
    default = "true"
}


variable "PM_LOG_LEVEL" {
    description = "The Proxmox log level"
    type = string
    default = "debug"
}


variable "PM_LOG_FILE" {
    description = "The Proxmox log file"
    type = string
    default = "terraform-plugin-proxmox.log"
}


variable "PM_HOST_NUM" {
    description = "The Proxmox VE host number"
    type = number
    default = 255
}


variable "NC_REGION" {
    description = "The NekkoCloud region"
    type = string
    default = ""
}


variable "NC_MK_IP" {
    description = "The NekkoCloud MK IP"
    type = string
    default = ""
}


variable "NC_UR_IP" {
    description = "The NekkoCloud UR IP"
    type = string
    default = ""
}


variable "NC_TU_IP" {
    description = "The NekkoCloud TU IP"
    type = string
    default = ""
}

# VM CONFIGURATION
variable "vm_name" {
    description = "The name of the VM"
    type = string
    default = ""
}


variable username {
    description = "The username to assign to the VM"
    type = string
    default = ""
}


variable password {
    description = "The password to assign to the VM"
    type = string
    default = ""
}


variable public_key {
    description = "The public key to be used for SSH"
    type = string
    default = ""
}


variable private_key {
    description = "The username to assign to the VM"
    type = string
    default = ""
}
