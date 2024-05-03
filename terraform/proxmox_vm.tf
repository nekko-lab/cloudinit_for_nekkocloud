# Description: This file contains the terraform configuration for creating a new VM on the Proxmox server.
# proxmox_vm_qemu: nc-<Region Name>
resource "proxmox_vm_qemu" "nc-vm-1" {
    count = local.clone_num
    desc  = "${local.description}"

    name        = "${var.vm_name}-${local.os_name}-${count.index}"
    target_node = local.target_node
    vmid        = local.vmid + count.index
    os_type     = local.os_type
    boot        = local.boot
    onboot      = local.onboot
    bootdisk    = local.bootdisk
    clone       = local.ci_name
    cpu         = local.cputype
    cores       = local.cores
    sockets     = local.sockets
    memory      = local.memory
    scsihw      = local.scsi_ctl_type

    disks {
        virtio {
            virtio0 {
                disk {
                    storage = local.storage_pool
                    size    = local.disk_size
                }
            }
        }

        scsi {
            scsi0 {
                disk {
                    storage = local.storage_pool
                    size    = local.disk_size
                }
            }
        }
    }

    network {
        model    = local.type
        bridge   = "vmbr0"
        firewall = false
    }

    ipconfig0               = "ip=${local.ip_add_net}${local.network_num + count.index}/24,gw=${local.ip_add_net}1"
    nameserver              = "${local.ip_add_net}1"
    ciuser                  = "${var.username}"
    cipassword              = "${var.password}"
    sshkeys                 = var.public_key
    agent                   = local.qemu_agent
    cloudinit_cdrom_storage	= local.storage_pool

    tags = "tf-${local.target_node}"
}
