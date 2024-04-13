# Description: This file contains the configuration for the backend of the terraform state file. This file is used to store the state file in the Proxmox server.
# locals: Argument reference
locals {
    boot         = "order=virtio0"
    os_type      = "cloud-init"
    type         = "virtio"
    storage_pool = "local-lvm" #cephfs
}

# VM config: Ubuntu 22.04
locals {
    ci_name-0   = "nc-vm-ubuntu22.04"
    vmid-0      = 2010
    clone-0     = 1
    cores-0     = 2
    memory-0    = 4096
    disk_size-0 = 32
    network_num = 50
}

# VM config: Vyos 1.3.3
locals {
    ci_name-1   = "nc-vm-vyos-1.3.3"
    vmid-1      = 1900
    clone-1     = 1
    cores-1     = 2
    memory-1    = 2048
    disk_size-1 = 16
}

# provider: Proxmox
terraform {
    required_providers {
        proxmox = {
            source  = "Telmate/proxmox"
            version = "3.0.1-rc1"
        }
    }
}

# provider: Proxmox
provider "proxmox" {
    pm_api_url          = var.PM_PROV_URL
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

# provider "kubernetes" {
#     config_path = var.kubeconfig
#     config_context = "docker-desktop"
# }
