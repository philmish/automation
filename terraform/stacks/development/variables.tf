variable "proxmox_api_url" {
  type = string
  description = "Base URL of the Proxmox instances API"
}

variable "proxmox_api_token_id" {
  type = string
  description = "ID used for the authentication with the Proxmox API"
  sensitive = true
}

variable "proxmox_api_token" {
  type = string
  description = "Token used for authenticating the ID with the Proxmox API"
  sensitive = true
}

variable "node" {
  type = string
  description = "Proxmox node to deploy the container on"
  default = "pve"
}

variable "ssh_keys" {
  type = list(string)
}

variable "storage" {
  type = string
  description = "Proxmox storage used to store the block storage of the vms"
  default = "local-lvm"
}

variable "cidomain" {
  type = string
  description = "searchdomain setup with cloud init"
}

variable "cidns" {
  type = string
  description = "Nameserver setup with cloud init"
}

variable "bridge" {
  type = string
  description = "Network bridge to use"
}

# services node

variable "services_templ" {
  type = number
  description = "vmid of the template used to setup the services node"
}

variable "services_user" {
  type = string
  description = "User used for CI setup of services node"
}

variable "services_pw" {
  type = string
  description = "Password used for the user setup with cloud init for the services node"
  sensitive = true
}

variable "services_ipconfig" {
  type = string
  description = "ipconfig for the network interface of the services node"
}

variable "services_host" {
  type = string
  description = "Host used in the ansible inventory produced for the services host"
}

variable "services_private_key" {
  type = string
  description = "Local path to ssh key used to provision services node"
}

# deployment node

variable "deployment_templ" {
  type = number
  description = "vmid of the template used to setup the deployment node"
}

variable "deployment_user" {
  type = string
  description = "User used for CI setup of deployment node"
}

variable "deployment_pw" {
  type = string
  description = "Password used for the user setup with cloud init for the deployment node"
  sensitive = true
}

variable "deployment_ipconfig" {
  type = string
  description = "ipconfig for the network interface of the deployment node"
}

variable "deployment_host" {
  type = string
  description = "Host used in the ansible inventory produced for the deployment host"
}

variable "deployment_private_key" {
  type = string
  description = "Local path to ssh key used to provision deployment node"
}

# monitoring node

variable "monitoring_templ" {
  type = number
  description = "vmid of the template used to setup the monitoring node"
}

variable "monitoring_user" {
  type = string
  description = "User used for CI setup of monitoring node"
}

variable "monitoring_pw" {
  type = string
  description = "Password used for the user setup with cloud init for the monitoring node"
  sensitive = true
}

variable "monitoring_ipconfig" {
  type = string
  description = "ipconfig for the network interface of the monitoring node"
}

variable "monitoring_host" {
  type = string
  description = "Host used in the ansible inventory produced for the monitoring host"
}

variable "monitoring_private_key" {
  type = string
  description = "Local path to ssh key used to provision monitoring node"
}
