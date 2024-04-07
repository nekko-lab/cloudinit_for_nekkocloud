# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# proxmox_cloud_init_disk: nc-<Region Name>-<VM Name>
resource "proxmox_cloud_init_disk" "nc-ur-ubuntu" {
  name     = "${var.PM_USER}-${var.vm_name}-ubuntu"
  pve_node = var.target_node
  storage  = local.iso_storage_pool

  meta_data      = var.ubuntu_meta_data
  user_data      = yamlencode("${var.ubuntu_user_data}")
  network_config = yamlencode("${var.ubuntu_network_config}")
}

# proxmox_cloud_init_disk: nc-<Region Name>-<VM Name>
# resource "proxmox_cloud_init_disk" "nc-ur-vyos" {
#   name     = var.PM_USER
#   pve_node = var.target_node
#   storage  = local.iso_storage_pool

#   meta_data      = var.vyos_meta_data
#   user_data      = yamlencode("${var.vyos_user_data}")
#   network_config = yamlencode("${var.vyos_network_config}")
# }