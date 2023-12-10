module "coredns_zonefiles_updater_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//configurations-auto-updater?ref=v0.14.0"
  install_dependencies = true
  filesystem = {
    path = "/opt/coredns/zonefiles"
    files_permission = "700"
    directories_permission = "700"
  }
  etcd = {
    key_prefix = "/coredns/"
    endpoints = [for node in local.params.network.machines.ops_nodes: "${node.ip}:2379"]
    connection_timeout = "10s"
    request_timeout = "10s"
    retry_interval = "500ms"
    retries = 10
    auth = {
      ca_certificate = module.etcd_ca.certificate
      client_certificate = module.etcd_root_credentials.certificate
      client_key = module.etcd_root_credentials.key
      username = ""
      password = ""
    }
  }
  naming = {
    binary = "coredns-zonefiles-updater"
    service = "coredns-zonefiles-updater"
  }
  user = "coredns"
}

module "ops_1_coredns_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//coredns?ref=v0.14.0"
  install_dependencies = true
  dns = {
    dns_bind_addresses = [local.params.network.machines.ops_nodes.0.ip]
    observability_bind_address = local.params.network.machines.ops_nodes.0.ip
    nsid = "ops-1"
    zonefiles_reload_interval = "3s"
    load_balance_records = true
    alternate_dns_servers = ["8.8.8.8"]
  }
}

module "ops_2_coredns_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//coredns?ref=v0.14.0"
  install_dependencies = true
  dns = {
    dns_bind_addresses = [local.params.network.machines.ops_nodes.1.ip]
    observability_bind_address = local.params.network.machines.ops_nodes.1.ip
    nsid = "ops-2"
    zonefiles_reload_interval = "3s"
    load_balance_records = true
    alternate_dns_servers = ["8.8.8.8"]
  }
}

module "ops_3_coredns_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//coredns?ref=v0.14.0"
  install_dependencies = true
  dns = {
    dns_bind_addresses = [local.params.network.machines.ops_nodes.2.ip]
    observability_bind_address = local.params.network.machines.ops_nodes.2.ip
    nsid = "ops-3"
    zonefiles_reload_interval = "3s"
    load_balance_records = true
    alternate_dns_servers = ["8.8.8.8"]
  }
}