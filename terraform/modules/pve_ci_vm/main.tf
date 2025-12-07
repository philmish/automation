resource "proxmox_vm_qemu" "pve-ci-vm" {
  name        = var.vmname
  target_node = var.node
  vmid        = 0
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"

  cpu {
    cores   = var.cores
    sockets = 1
  }

  clone_id  = var.template_id
  onboot    = true

  # Cloud-Init settings
  ciuser       = var.ciuser
  cipassword   = var.cipassword
  sshkeys      = join("\n", var.ssh_keys)
  searchdomain = var.cidomain
  nameserver   = var.cidns

  ipconfig0 = var.network_config

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = var.storage
          size = var.disk_size
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = var.bridge
  }
}
