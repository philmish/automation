resource "proxmox_vm_qemu" "pve_talos_k8s" {
  vmid        = 0
  name        = var.vmname
  target_node = var.node
  memory      = var.memory

  cpu {
    cores   = var.cores
    sockets = 1
  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.disk_storage
          size    = var.disk_size
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "${var.iso_storage}:iso/${var.iso_name}"
        }
      }
    }
  }

  onboot     = true
  scsihw     = "virtio-scsi-pci"


  network {
    id     = 0
    model  = var.nic_model
    bridge = var.network_bridge
  }

  nameserver = var.name_servers[0]
  ipconfig0  = var.ip_config
}
