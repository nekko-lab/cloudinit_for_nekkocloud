# PROXMOX PROVIDER CONFIGURATION
variable "PM_PROV_URL" {
    description = "The Proxmox Provider URL"
    type = string
    default = ""
}


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


variable "PM_LOG_FILE" {
    description = "The Proxmox log file"
    type = string
    default = "terraform-plugin-proxmox.log"
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


variable target_node {
    description = "The Proxmox node to deploy the VM"
    type = string
    default = ""
}


variable ip_address_networkpart {
    description = "The number of cores to assign to the VM"
    type = string
    default = "192.168.0."
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
