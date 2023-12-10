resource "libvirt_volume" "ceph_1" {
  name             = "ceph-1"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_1_data_1" {
  name             = "ceph-1-data-1"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_1_data_2" {
  name             = "ceph-1-data-2"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_1_data_3" {
  name             = "ceph-1-data-3"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_1_data_4" {
  name             = "ceph-1-data-4"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_2" {
  name             = "ceph-2"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_2_data_1" {
  name             = "ceph-2-data-1"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_2_data_2" {
  name             = "ceph-2-data-2"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_2_data_3" {
  name             = "ceph-2-data-3"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_2_data_4" {
  name             = "ceph-2-data-4"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_3" {
  name             = "ceph-3"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  base_volume_pool = "ceph"
  base_volume_name = "ubuntu-jammy-2023-10-26"
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_3_data_1" {
  name             = "ceph-3-data-1"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_3_data_2" {
  name             = "ceph-3-data-2"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_3_data_3" {
  name             = "ceph-3-data-3"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

resource "libvirt_volume" "ceph_3_data_4" {
  name             = "ceph-3-data-4"
  pool             = "ceph"
  size             = 10 * 1024 * 1024 * 1024
  format           = "qcow2"
}

module "ceph_1" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ceph-1"
  vcpus = 2
  memory = 12288
  volume_ids = [
    libvirt_volume.ceph_1.id,
    libvirt_volume.ceph_1_data_1.id,
    libvirt_volume.ceph_1_data_2.id,
    libvirt_volume.ceph_1_data_3.id,
    libvirt_volume.ceph_1_data_4.id
  ]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ceph_nodes.0.ip
    mac = local.params.network.machines.ceph_nodes.0.mac
    gateway = local.params.network.gateway
    dns_servers = [
      local.params.network.machines.ops_nodes.0.ip,
      local.params.network.machines.ops_nodes.1.ip,
      local.params.network.machines.ops_nodes.2.ip
    ]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
        filename = "ceph_node.cfg"
        content = file("${path.module}/terraform-cloudinit/ceph-node/user_data.yaml")
    },
    {
        filename = "cephadm.cfg"
        content = file("${path.module}/terraform-cloudinit/cephadm/user_data.yaml")
    }
  ]
}

module "ceph_2" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ceph-2"
  vcpus = 2
  memory = 12288
  volume_ids = [
    libvirt_volume.ceph_2.id,
    libvirt_volume.ceph_2_data_1.id,
    libvirt_volume.ceph_2_data_2.id,
    libvirt_volume.ceph_2_data_3.id,
    libvirt_volume.ceph_2_data_4.id
  ]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ceph_nodes.1.ip
    mac = local.params.network.machines.ceph_nodes.1.mac
    gateway = local.params.network.gateway
    dns_servers = [
      local.params.network.machines.ops_nodes.0.ip,
      local.params.network.machines.ops_nodes.1.ip,
      local.params.network.machines.ops_nodes.2.ip
    ]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
      filename = "ceph_node.cfg"
      content = file("${path.module}/terraform-cloudinit/ceph-node/user_data.yaml")
    },
    {
      filename = "cephadm.cfg"
      content = file("${path.module}/terraform-cloudinit/cephadm/user_data.yaml")
    }
  ]
}

module "ceph_3" {
  source = "git::https://github.com/Ferlab-Ste-Justine/terraform-libvirt-custom-server.git?ref=b1b289b90d1e0f634627822e35e42ba2375c505c"
  name = "ceph-3"
  vcpus = 2
  memory = 12288
  volume_ids = [
    libvirt_volume.ceph_3.id,
    libvirt_volume.ceph_3_data_1.id,
    libvirt_volume.ceph_3_data_2.id,
    libvirt_volume.ceph_3_data_3.id,
    libvirt_volume.ceph_3_data_4.id
  ]
  libvirt_networks = [{
    network_name = "ceph"
    network_id = ""
    prefix_length = split("/", local.params.network.addresses).1
    ip = local.params.network.machines.ceph_nodes.2.ip
    mac = local.params.network.machines.ceph_nodes.2.mac
    gateway = local.params.network.gateway
    dns_servers = [
      local.params.network.machines.ops_nodes.0.ip,
      local.params.network.machines.ops_nodes.1.ip,
      local.params.network.machines.ops_nodes.2.ip
    ]
  }]
  cloud_init_volume_pool = "ceph"
  admin_user_password = local.params.virsh_console_password
  ssh_admin_public_key = file("${path.module}/../shared/ssh_key_public")
  cloud_init_configurations = [
    {
      filename = "ceph_node.cfg"
      content = file("${path.module}/terraform-cloudinit/ceph-node/user_data.yaml")
    },
    {
      filename = "cephadm.cfg"
      content = file("${path.module}/terraform-cloudinit/cephadm/user_data.yaml")
    }
  ]
}