# locals: Argument reference
locals {
  target_node   = var.NC_REGION        # Proxmox node
  boot          = "order=virtio0;ide2" # Boot order
  onboot        = true                 # Start VM on boot
  bootdisk      = "virtio0, ide2"      # Boot disk
  os_type       = "cloud-init"         # OS type
  cputype       = "host"               # CPU type
  scsi_ctl_type = "virtio-scsi-pci"    # SCSI controller type
  type          = "virtio"             # Disk type
  storage_pool  = "local-lvm"          # cephfs local-nvme local-lvm
  qemu_agent    = 0                    # QEMU agent
}

# locals: VM configuration
locals {
  os_name     = "ubuntu"
  ci_name     = "ubuntu-22.04-server-cloudimg-amd64"
  description = "Ubuntu 22.04 server VM on Proxmox VE, ${var.NC_REGION} region by Terraform"
  vmid        = 4000 
  clone_num   = 1
  cores       = 2
  memory      = 4096
  balloon     = 1024
  disk_size   = 32
  sockets     = 1
  #If you want to use a static IP address, uncomment the following line and comment the above line.
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
