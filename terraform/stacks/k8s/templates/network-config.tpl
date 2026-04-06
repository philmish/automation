version: 1
config:
  - type: physical
    name: eth0
    mac_address: "${mac_address}"
    subnets:
      - type: static
        address: ${ip_address}
        netmask: ${netmask}
        gateway: ${gateway}
