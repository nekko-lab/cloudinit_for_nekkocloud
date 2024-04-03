# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
resource "proxmox_vm_qemu" "nc-ur-ubuntu" {
    count       = local.replicas-0
    desc        = "Ubuntu 22.04 VM on Proxmox by Terraform"
    name        = "${var.vm_name}-ubuntu-${count.index}"
    target_node = var.target_node
    vmid        = "${local.vmid-0 + count.index}"
    os_type     = local.os_type
    boot        = local.boot
    iso         = local.ubuntu-2204
    cores       = local.cores-0
    memory      = local.memory-0

    disk {
        storage = "local-lvm"
        type    = "virtio"
        size    = "${local.disk_size-0}G"
    }

    network {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0 = "ip=${var.ip_address_networkpart}${10 + count.index}/24,gw=${var.ip_address_networkpart}0"
    ciuser    = var.username
    sshkeys   = var.public_key

    tags = "tf-${var.target_node}"
}

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
resource "proxmox_vm_qemu" "nc-ur-vyos" {
    count       = local.replicas-1
    desc        = "Vyos 1.3.3 VM on Proxmox by Terraform"
    name        = "${var.vm_name}-vyos-${count.index}"
    target_node = var.target_node
    vmid        = "${local.vmid-1 + count.index}"
    os_type     = local.os_type
    boot        = local.boot
    iso         = local.vyos-133
    cores       = local.cores-1
    memory      = local.memory-1

    disk {
        storage = "local-lvm"
        type    = "virtio"
        size    = "${local.disk_size-1}G"
    }

    network {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0 = "ip=${var.ip_address_networkpart}${5 + count.index}/24,gw=${var.ip_address_networkpart}0"
    ciuser    = var.username
    sshkeys   = var.public_key

    tags = "tf-${var.target_node}"
}
