# proxmox_vm_qemu:
resource "proxmox_vm_qemu" "nc-vm-1" {
  # Required arguments
  count       = local.clone_num                                   # Number of VMs to create
  desc        = local.description                                 # Description of the VM
  name        = "${var.vm_name}-${local.os_name}-${count.index}"  # Name of the VM
  target_node = local.target_node                                 # Proxmox node
  vmid        = local.vmid + count.index                          # VM ID
  os_type     = local.os_type                                     # OS type
  boot        = local.boot                                        # Boot order
  onboot      = local.onboot                                      # Start VM on boot
  bootdisk    = local.bootdisk                                    # Boot disk
  clone       = local.ci_name                                     # Clone from template
  cpu         = local.cputype                                     # CPU type
  cores       = local.cores                                       # Number of CPU cores
  sockets     = local.sockets                                     # Number of CPU sockets
  memory      = local.memory                                      # Memory size
  balloon     = local.balloon                                     # Minimum memory size
  scsihw      = local.scsi_ctl_type                               # SCSI controller type

  disks {
    virtio {
      virtio0 { # Boot disk
        disk {
          storage = local.storage_pool  # Storage pool
          size    = local.disk_size     # Disk size
        }
      }
    }
    ide {
      ide2 { # Cloud-init disk
        cloudinit {
          storage = local.storage_pool  # Storage pool
        }
      }
    }
  }

  network {
    model    = "virtio"       # Network model
    bridge   = local.vmbr_num # Bridge
    firewall = false          # Enable firewall
  }

  ciuser     = var.username       # Cloud-init username
  cipassword = var.password       # Cloud-init password
  sshkeys    = var.public_key     # SSH public key
  agent      = local.qemu_agent   # QEMU agent
  ipconfig0  = "ip=dhcp,ip6=auto" # DHCP: Dynamic IP address

  #If you want to use a static IP address, uncomment the following line and comment the above line.
  #And don't forget to uncomment the network_num on \"backend.tf\" in locals \"VM configuration\".
  # ipconfig0  =  "ipv6=${local.ip_add_net}${local.network_num + count.index}/24,gwv6=${local.ip_add_net}1"

  tags = "${local.target_node}_${var.NC_RSC_POOL}" # Nekko Cloud Region Resource Tag
}
