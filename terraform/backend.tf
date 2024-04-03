# Description: This file contains the configuration for the backend of the terraform state file. This file is used to store the state file in the Proxmox server.
# locals: Argument reference
locals {
    boot    = "order=virtio0"
    os_type = "cloud-init"
    iso_storage_pool = "local-lvm" #cephfs
}

# VM config: Ubuntu 22.04
locals {
    # ubuntu-2204 = "local:iso/ubuntu-22.04-server-cloudimg-amd64.img"
    ubuntu-2204 = "ubuntu-22.04"
    vmid-0      = 2010
    replicas-0  = 10
    cores-0     = 2
    memory-0    = 4096
    disk_size-0 = 128
}

# VM config: Vyos 1.3.3
locals {
    vyos-133    = "local:iso/vyos-1.3.3-amd64.iso"
    vmid-1      = 1900
    replicas-1  = 1
    cores-1     = 2
    memory-1    = 2048
    disk_size-1 = 16
}

# provider: Proxmox
terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}

# provider: Proxmox
provider "proxmox" {
    pm_api_url          = var.PM_PROV_URL
    # pm_user             = var.PM_USER
    # pm_password         = var.PM_PASS
    pm_api_token_id     = var.PM_API_TOKEN_ID
    pm_api_token_secret = var.PM_API_TOKEN_SECRET
    pm_tls_insecure     = true
    pm_debug            = true
    pm_log_enable       = true
    pm_log_file         = var.PM_LOG_FILE
    pm_log_levels       = {
        _default    = "debug"
        # _capturelog = ""
    }
}

