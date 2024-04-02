# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# locals: Argument reference
locals {
    vm_name     = "nc-vm"
    vmid-0      = 2010
    boot        = "order=virtio0"
    os_type     = "cloud-init"

    ubuntu-2204 = "local:iso/jammy-server-cloudimg-amd64.img"
    cores-0     = 2
    memory-0    = 4096
    disk_size-0 = 128

    vyos-133    = "local:iso/vyos-1.3.3-amd64.iso"
    cores-1     = 2
    memory-1    = 2048
    disk_size-1 = 16
}

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
resource "proxmox_vm_qemu" "nc-ur-ubuntu" {
    desc        = "Ubuntu 22.04 VM on Proxmox by Terraform"
    name        = "${local.vm_name}-ubuntu-${count.index}"
    target_node = var.target_node
    vmid        = local.vmid + count.index
    os_type     = local.os_type
    boot        = local.boot
    iso         = local.ubuntu-2204
    cores       = var.cores-0
    memory      = var.memory-0

    disk {
        storage = "local-lvm"
        type    = "virtio"
        size    = "${var.disk_size-0}G"
    }

    network {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0 = "ip=${var.ip_address_networkpart}${10 + count.index}/24,gw=${var.ip_address_networkpart}0"
    ciuser    = var.username
    sshkeys   = var.public_key

    tags = {
        Name = "tf-${var.target_node}"
    }
}

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
resource "proxmox_vm_qemu" "nc-ur-vyos" {
    desc        = "Vyos 1.3.3 VM on Proxmox by Terraform"
    name        = "${local.vm_name}-vyos-${count.index}"
    target_node = local.target_node
    vmid        = local.vmid + count.index
    os_type     = local.os_type
    boot        = local.boot
    iso         = local.vyos-133
    cores       = var.cores-1
    memory      = var.memory-1

    disk {
        storage = "local-lvm"
        type    = "virtio"
        size    = "${var.disk_size-1}G"
    }

    network {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0 = "ip=${var.ip_address_networkpart}${5 + count.index}/24,gw=${var.ip_address_networkpart}0"
    ciuser    = var.username
    sshkeys   = var.public_key
}
