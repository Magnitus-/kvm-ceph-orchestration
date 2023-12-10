resource "libvirt_volume" "ops_1" {
  name             = "ops-1"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

resource "libvirt_volume" "ops_2" {
  name             = "ops-2"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

resource "libvirt_volume" "ops_3" {
  name             = "ops-3"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

module "ops_1" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ops-1"
  vcpus = 1
  memory = 8192
  volume_ids = [libvirt_volume.ops_1.id]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ops_nodes.0.ip
    mac = local.params.network.machines.ops_nodes.0.mac
    gateway = local.params.network.gateway
    dns_servers = [local.params.network.dns]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
      filename = "etcd.cfg"
      content = module.ops_1_etcd_configs.configuration
    },
    {
      filename = "coredns_updater.cfg"
      content = module.coredns_zonefiles_updater_configs.configuration
    },
    {
      filename = "coredns.cfg"
      content = module.ops_1_coredns_configs.configuration
    }
  ]
}

module "ops_2" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ops-2"
  vcpus = 1
  memory = 8192
  volume_ids = [libvirt_volume.ops_2.id]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ops_nodes.1.ip
    mac = local.params.network.machines.ops_nodes.1.mac
    gateway = local.params.network.gateway
    dns_servers = [local.params.network.dns]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
      filename = "etcd.cfg"
      content = module.ops_2_etcd_configs.configuration
    },
    {
      filename = "coredns_updater.cfg"
      content = module.coredns_zonefiles_updater_configs.configuration
    },
    {
      filename = "coredns.cfg"
      content = module.ops_2_coredns_configs.configuration
    }
  ]
}

module "ops_3" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ops-3"
  vcpus = 1
  memory = 8192
  volume_ids = [libvirt_volume.ops_3.id]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ops_nodes.2.ip
    mac = local.params.network.machines.ops_nodes.2.mac
    gateway = local.params.network.gateway
    dns_servers = [local.params.network.dns]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
      filename = "etcd.cfg"
      content = module.ops_3_etcd_configs.configuration
    },
    {
      filename = "coredns_updater.cfg"
      content = module.coredns_zonefiles_updater_configs.configuration
    },
    {
      filename = "coredns.cfg"
      content = module.ops_3_coredns_configs.configuration
    }
  ]
}