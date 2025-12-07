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

variable "vmname" {
  type = string
  description = "Name of the VM"
}

variable "memory" {
  type = number
  default = 4096
}

variable "cores" {
  type = number
  default = 2
}

variable "disk_size" {
  type = string
  default = "20G"
}

variable "storage" {
  type = string
  default = "local-lvm"
}

variable "ssh_keys" {
  type = list(string)
}

variable "ciuser" {
  type = string
  description = "User used with cloud init to setup host"
}

variable "cipassword" {
  type = string
  description = "Password used for the user setup with cloud init"
  sensitive = true
}

variable "cidomain" {
  type = string
  description = "searchdomain setup with cloud init"
}

variable "cidns" {
  type = string
  description = "Nameserver setup with cloud init"
}

variable "template_id" {
  type = number
  description = "vmid of the template to use"
}

variable "bridge" {
  type = string
  description = "Network bridge to use"
}

variable "network_config" {
  type = string
  description = "ipconfig0"
}
