# Description: This file contains the configuration for the backend of the terraform state file. This file is used to store the state file in the Proxmox server.
# locals: Argument reference
locals {
  target_node   = "${var.NC_REGION}"
  boot          = "order=virtio0"
  onboot        = true
  bootdisk      = "virtio0, ide2"
  os_type       = "cloud-init"
  cputype       = "host"
  scsi_ctl_type = "virtio-scsi-pci"
  type          = "virtio"
  storage_pool  = "local-lvm" # cephfs local-nvme local-lvm
  qemu_agent    = 0
}

# locals: VM config Ubuntu 22.04 nc-vm-ubuntu22.04
locals {
  os_name     = "ubuntu"
  ci_name     = "ubuntu-22.04-server-cloudimg-amd64"
  description = "Ubuntu 22.04 VM on Proxmox by Terraform"
  vmid        = 4000
  clone_num   = 1
  cores       = 2
  memory      = 4096
  balloon     = 1024
  disk_size   = 32
  sockets     = 1
  # network_num = 
  ip_add_net  = var.NC_REGION_DEV_IP[var.NC_REGION]
  vmbr_num    = var.vm_br[var.NC_RSC_POOL]
}

# provider: Telmate Proxmox
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }

  backend "local" {}
}

# provider: Telmate Proxmox
provider "proxmox" {
  pm_api_url          = "https://[${local.ip_add_net}101]:8006/api2/json"
  pm_api_token_id     = var.PM_API_TOKEN_ID
  pm_api_token_secret = var.PM_API_TOKEN_SECRET
  pm_tls_insecure     = var.PM_TLS_INSECURE
  pm_debug            = var.PM_DEBUG
  pm_log_enable       = var.PM_LOG_ENABLE
  pm_log_file         = var.PM_LOG_FILE
  pm_log_levels = {
    default = "debug"
    # _capturelog = ""
  }
}
