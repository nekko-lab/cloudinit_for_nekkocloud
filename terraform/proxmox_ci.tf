# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# proxmox_cloud_init_disk: nc-<Region Name>-<VM Name>
resource "proxmox_cloud_init_disk" "nc-ur-ubuntu" {
    name     = PM_USER
    pve_node = var.target_node
    storage  = local.iso_storage_pool

    meta_data      = var.ubuntu-meta_data
    user_data      = var.ubuntu-user_data
    network_config = var.ubuntu-network_config
}

# proxmox_cloud_init_disk: nc-<Region Name>-<VM Name>
resource "proxmox_cloud_init_disk" "nc-ur-vyos" {
    name     = PM_USER
    pve_node = var.target_node
    storage  = local.iso_storage_pool

    meta_data      = var.vyos-meta_data
    user_data      = var.vyos-user_data
    network_config = var.vyos-network_config
}
