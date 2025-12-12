locals {
  vms = {
    services = {
      vmname    = "dev-services"
      memory    = 8192
      cores     = 4
      disk_size = "40G"
      templ     = var.services_templ
      ci_user   = var.services_user
      ci_pw     = var.services_pw
      ipconfig  = var.services_ipconfig
    }
    deployment = {
      vmname    = "dev-deployment"
      memory    = 2048
      cores     = 2
      disk_size = "20G"
      templ     = var.deployment_templ
      ci_user   = var.deployment_user
      ci_pw     = var.deployment_pw
      ipconfig  = var.deployment_ipconfig
    }
    monitoring = {
      vmname    = "dev-monitoring"
      memory    = 4096
      cores     = 2
      disk_size = "20G"
      templ     = var.monitoring_templ
      ci_user   = var.monitoring_user
      ci_pw     = var.monitoring_pw
      ipconfig  = var.monitoring_ipconfig
    }
  }
}

module "development_stack" {
  source = "../../modules/pve_ci_vm"

  for_each       = local.vms
  node           = var.node
  vmname         = each.value.vmname
  memory         = each.value.memory
  cores          = each.value.cores
  template_id    = each.value.templ
  ciuser         = each.value.ci_user
  cipassword     = each.value.ci_pw
  network_config = each.value.ipconfig
  disk_size      = each.value.disk_size
  storage        = var.storage
  ssh_keys       = var.ssh_keys
  cidomain       = var.cidomain
  cidns          = var.cidns
  bridge         = var.bridge

}
