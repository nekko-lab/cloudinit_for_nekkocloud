# variables
variable "clonenum" {}
variable "description" {}
variable "vm_name" {}
variable "target_node" {}
variable "vmid" {}
variable "os_type" {}
variable "boot" {}
variable "ci_clone" {}
variable "cputype" {}
variable "core" {}
variable "socket" {}
variable "memory" {}
variable "storage_pool" {}
variable "disk_size" {}
variable "type" {}
variable "ip_address_networkpart" {}
variable "username" {}
variable "password" {}
variable "qemu_agent" {}
variable "public_key" {}
variable "network_num" {}

# provider: Telmate Proxmox
terraform {
    required_providers {
        proxmox = {
            source  = "Telmate/proxmox"
            version = "~> 2.7"
        }
    }
}

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
resource "proxmox_vm_qemu" "nc-ur-ubuntu" {
    count       = var.clonenum
    desc        = "${var.description}"

    name        = "${var.vm_name}-ubuntu-${count.index}"
    target_node = var.target_node
    vmid        = "${var.vmid + count.index}"
    os_type     = var.os_type
    boot        = var.boot
    clone       = var.ci_clone
    cpu         = var.cputype
    cores       = var.core
    sockets     = var.socket
    memory      = var.memory

    disks {
        virtio {
            virtio0 {
                disk {
                    storage = var.storage_pool
                    size    = var.disk_size
                }
            }
        }
    }

    network {
        model    = var.type
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0  = "ip=${var.ip_address_networkpart}${var.network_num + count.index}/24,gw=${var.ip_address_networkpart}0"
    ciuser     = var.username
    cipassword = var.password
    sshkeys    = var.public_key
    agent      = var.qemu_agent

    tags = "tf-${var.target_node}"
}


output "proxmox_vm_output" {
    value = proxmox_vm_qemu.nc-ur-ubuntu
}
