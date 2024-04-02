# PROXMOX PROVIDER CONFIGURATION
variable "PM_PROV_URL" {
    description = "The Proxmox Provider URL"
    type = string
}


variable "PM_USER" {
    description = "The Proxmox user"
    type = string
}


variable "PM_PASS" {
    description = "The Proxmox login password"
    type = string
}


variable "PM_API_TOKEN_ID" {
    description = "The Proxmox API Token ID"
    type = string
}


variable "PM_API_TOKEN_SECRET" {
    description = "The Proxmox API Token Secret"
    type = string
}


variable "PM_LOG_FILE" {
    description = "The Proxmox log file"
    type = string
    default = "terraform-plugin-proxmox.log"
}

# VM CONFIGURATION
variable username {
    description = "The username to assign to the VM"
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
}


variable private_key {
    description = "The username to assign to the VM"
    type = string
}
