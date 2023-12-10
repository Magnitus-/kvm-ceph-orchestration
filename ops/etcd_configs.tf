locals {
  etcd_cluster = {
    auto_compaction_mode      = "revision"
    auto_compaction_retention = "1000"
    space_quota               = 8*1024*1024*1024
    grpc_gateway_enabled      = false
    client_cert_auth          = true
    root_password             = ""
  }
  etcd_initial_cluster = {
    is_initializing = true
    token = "etcd"
    members = [
      {
        name = "ops-1"
        ip   = local.params.network.machines.ops_nodes.0.ip
      },
      {
        name = "ops-2"
        ip   = local.params.network.machines.ops_nodes.1.ip
      },
      {
        name = "ops-3"
        ip   = local.params.network.machines.ops_nodes.2.ip
      }
    ]
  }
  etcd_tls = {
    server_cert = tls_locally_signed_cert.etcd.cert_pem
    server_key  = tls_private_key.etcd.private_key_pem
    ca_cert     = module.etcd_ca.certificate
  }
}

module "ops_1_etcd_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//etcd?ref=v0.14.0"
  install_dependencies = true
  etcd_host = {
    name                     = "ops-1"
    ip                       = local.params.network.machines.ops_nodes.0.ip
    bootstrap_authentication = true
  }
  etcd_cluster = local.etcd_cluster
  etcd_initial_cluster = local.etcd_initial_cluster
  tls = local.etcd_tls
}

module "ops_2_etcd_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//etcd?ref=v0.14.0"
  install_dependencies = true
  etcd_host = {
    name                     = "ops-2"
    ip                       = local.params.network.machines.ops_nodes.1.ip
    bootstrap_authentication = false
  }
  etcd_cluster = local.etcd_cluster
  etcd_initial_cluster = local.etcd_initial_cluster
  tls = local.etcd_tls
}

module "ops_3_etcd_configs" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-cloudinit-templates.git//etcd?ref=v0.14.0"
  install_dependencies = true
  etcd_host = {
    name                     = "ops-3"
    ip                       = local.params.network.machines.ops_nodes.2.ip
    bootstrap_authentication = false
  }
  etcd_cluster = local.etcd_cluster
  etcd_initial_cluster = local.etcd_initial_cluster
  tls = local.etcd_tls
}