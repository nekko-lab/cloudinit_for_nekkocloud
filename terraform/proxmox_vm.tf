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

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
# resource "proxmox_vm_qemu" "nc-ur-ubuntu" {
#     count       = local.clone-0
#     desc        = "Ubuntu 22.04 VM on Proxmox by Terraform"

#     name        = "${var.vm_name}-ubuntu-${count.index}"
#     target_node = var.target_node
#     vmid        = "${local.vmid-0 + count.index}"
#     os_type     = local.os_type
#     boot        = local.boot
#     clone       = local.ci_name-0
#     cpu         = "host"
#     cores       = local.cores-0
#     sockets     = 1
#     memory      = local.memory-0

#     disks {
#         virtio {
#             virtio0 {
#                 disk {
#                     storage      = local.storage_pool
#                     size         = local.disk_size-0
#                 }
#             }
#         }
#     }

#     network {
#         model    = local.type
#         bridge   = "vmbr0"
#         firewall = false
#     }

#     ipconfig0  = "ip=${var.ip_address_networkpart}${local.network_num + count.index}/24,gw=${var.ip_address_networkpart}0"
#     ciuser     = var.username
#     cipassword = var.password
#     sshkeys    = var.public_key

#     tags = "tf-${var.target_node}"
# }

# proxmox_cloud_init_disk: nc-<Region Name>-<VM Name>
#resource "proxmox_cloud_init_disk" "nc-ur-ubuntu" {
#    name     = "${var.vm_name}-ubuntu"
#    pve_node = var.target_node
#    storage  = local.storage_pool#

#    meta_data      = yamlencode({
#        instance_id    = sha1(var.vm_name)
#        local-hostname = var.vm_name
#    })

#    user_data      = <<EOF
#timezone: Asia/Tokyo
#locale: ja_JP.utf8
#package_update: true
#package_upgrade: true
#runcmd:
#- apt-get -y install inetutils-ping
#- apt-get -y install net-tools
#- apt-get -y install nc
#power_state:
#delay: "+10"
#mode: reboot
#message: Rebooting ...
#timeout: 30
#EOF

#    network_config = yamlencode({
#    version = 1
#    config = [{
#        type = "physical"
#        name = "eth0"
#        subnets = [{
#            type            = "static"
#            address         = "172.19.0.100/24"
#            gateway         = "172.19.0.1"
#            dns_nameservers = ["172.16.0.1", "1.1.1.1", "8.8.8.8"]
#            }]
#        }]
#    })
#}

#=============================================================#

# proxmox_vm_qemu: nc-<Region Name>-<VM Name>
# resource "proxmox_vm_qemu" "nc-ur-vyos" {
#     count       = local.clone-1
#     desc        = "Vyos 1.3.3 VM on Proxmox by Terraform"
#     name        = "${var.vm_name}-vyos-${count.index}"
#     target_node = var.target_node
#     vmid        = "${local.vmid-1 + count.index}"
#     os_type     = local.os_type
#     boot        = local.boot
#     iso         = local.ci_name-1
#     cores       = local.cores-1
#     memory      = local.memory-1

#     disk {
#         storage = "local-lvm"
#         type    = "virtio"
#         size    = "${local.disk_size-1}G"
#     }

#     network {
#         model    = "virtio"
#         bridge   = "vmbr0"
#         firewall = false
#     }

#     ipconfig0  = "ip=${var.ip_address_networkpart}${5 + count.index}/24,gw=${var.ip_address_networkpart}0"
#     ciuser     = var.username
#     cipassword = var.password
#     sshkeys    = var.public_key

#     tags = "tf-${var.target_node}"
# }
