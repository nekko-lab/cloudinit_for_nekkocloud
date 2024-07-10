# Description: This file contains the configuration for the backend of the terraform state file. This file is used to store the state file in the Proxmox server.
# locals: Argument reference
locals {
  target_node   = "${var.NC_REGION}"
  boot          = "order=scsi0"
  onboot        = true
  bootdisk      = "scsi0"
  os_type       = "cloud-init"
  cputype       = "host"
  scsi_ctl_type = "virtio-scsi-single"
  type          = "virtio"
  storage_pool  = "local-nvme-1" # cephfs local-nvme local-lvm
  qemu_agent    = 0
}

# locals: VM config Ubuntu 22.04 nc-vm-ubuntu22.04
locals {
  os_name     = "ubuntu"
  ci_name     = "Ubuntu-server-Cloudimg-22.04"
  description = "Ubuntu 22.04 VM on Proxmox by Terraform"
  vmid        = 40000
  clone_num   = 1
  cores       = 2
  memory      = 4096
  disk_size   = 32
  sockets     = 1
  network_num = 80
  ip_add_net  = var.NC_REGION_DEV_IP[var.NC_REGION]
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
