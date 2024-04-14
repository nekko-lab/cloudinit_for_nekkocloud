# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# module: proxmox_vm_qemu
module "proxmox_vm_ubuntu" {
    source      = "./modules"
    description = "Ubuntu 22.04 VM on Proxmox by Terraform"
    clonenum    = local.clone-0

    vm_name     = "${var.vm_name}"
    target_node = var.target_node
    vmid        = "${local.vmid-0}"
    os_type     = local.os_type
    boot        = local.boot
    ci_clone    = local.ci_name-0
    cputype     = "host"
    core        = local.cores-0
    socket      = local.socket-0
    memory      = local.memory-0

    storage_pool = local.storage_pool
    disk_size    = local.disk_size-0
    
    type                   = local.type
    ip_address_networkpart = var.ip_address_networkpart
    username               = var.username
    password               = var.password
    qemu_agent             = local.qemu_agent
    public_key             = var.public_key
    network_num            = local.network_num-0
}
