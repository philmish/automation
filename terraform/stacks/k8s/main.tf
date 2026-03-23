locals {
  nodes = {
    controlplane = {
      vmname    = "controlplane.talos"
      memory    = 8192
      cores     = 4
      disk_size = "60G"
      ipconfig  = var.controlplane_ipconfig
    }
    worker1 = {
      vmname    = "worker-1.talos"
      memory    = 4096
      cores     = 2
      disk_size = "40GB"
      ipconfig  = var.worker1_ipconfig
    }
    worker2 = {
      vmname   = "worker-2.talos"
      memory    = 4096
      cores     = 2
      disk_size = "40GB"
      ipconfig  = var.worker2_ipconfig
    }
  }
}

module "talos_k8s" {
  source   = "../../modules/pve_talos_k8s"

  for_each = local.nodes
  node     = var.node
  vmname   = each.value.vmname
  memory   = each.value.memory
  cores    = each.value.cores
  ipconfig = each.value.ipconfig

}
