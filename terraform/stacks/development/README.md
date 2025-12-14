# Development Stack

This stack is intended to be used to create VMs for development purposes. This stack relys on Cloud Init ready VM templates. It provides 3 VMs:

1. Services - a VM used for running services like databases, which are consumed over the network by the developed application
2. Deployment - a VM used to deploy the developed application
3. Monitoring - a VM used to provided monitoring for all VMs in this stack, like log aggregation or metric tracking

After setting up the development stack virtual machines, an `Ansible` inventory file will be created at the root of the repository, which then can be used to setup and configure the newly created VMs further.

To create all VMs in this stack a `secrets.auto.tfvars` should be created in this directory, containing the following information:


```tfvars
# Proxmox API Creds
proxmox_api_url      = "https://my-promox-url:8006/api2/json"
proxmox_api_token_id = "my-token@pve!my-api-user"
proxmox_api_token    = "my-super-secret-api-token"
# SSH Keys
ssh_keys             = ["SSH Key"]
# Network
cidns                = "192.168.5.1"
bridge               = "vmbr4"
cidomain             = "dev.net"
# Services Node
services_templ       = 9000
services_user        = "services"
services_pw          = "services-pw"
services_ipconfig    = "ip=192.168.5.6/24,gw=192.168.5.1"
# this is used during ansible inventory creation as the ansible_host for this vm
services_host        = "192.168.5.6"
# this is used during ansible inventory creation as the ansible_private_key_file for this vm
services_private_key = "/path/to/your/local/ssh_private_key"
# Deployment Node
deployment_templ     = 9000
deployment_user      = "deployment"
deployment_pw        = "deployment-pw"
deployment_ipconfig  = "ip=192.168.5.7/24,gw=192.168.5.1"
# this is used during ansible inventory creation as the ansible_host for this vm
deployment_host        = "192.168.5.7"
# this is used during ansible inventory creation as the ansible_private_key_file for this vm
deployment_private_key = "/path/to/your/local/ssh_private_key"
# Monitoring Node
monitoring_templ     = 9000
monitoring_user      = "monitoring"
monitoring_pw        = "monitoring-pw"
monitoring_ipconfig  = "ip=192.168.5.8/24,gw=192.168.5.1"
# this is used during ansible inventory creation as the ansible_host for this vm
monitoring_host        = "192.168.5.8"
# this is used during ansible inventory creation as the ansible_private_key_file for this vm
monitoring_private_key = "/path/to/your/local/ssh_private_key"
```

Replace all the example values above with the ones you are using for your lab. This will
