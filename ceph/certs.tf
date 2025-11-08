module "ceph_ca" {
  source = "./ca"
  common_name = "ceph"
}

resource "tls_private_key" "ceph" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "tls_cert_request" "ceph" {
  private_key_pem = tls_private_key.ceph.private_key_pem
  ip_addresses    = concat(
    [
      local.params.network.machines.ceph_nodes.0.ip,
      local.params.network.machines.ceph_nodes.1.ip,
      local.params.network.machines.ceph_nodes.2.ip,
      local.params.network.machines.ceph_nodes.3.ip,
      split("/", local.params.network.rgw_ingress_ip).0
    ], 
    ["127.0.0.1"]
  )
  dns_names = [
    "*.ceph.lan"
  ]
  subject {
    common_name  = "ceph"
    organization = "Ferlab"
  }
}

resource "tls_locally_signed_cert" "ceph" {
  cert_request_pem   = tls_cert_request.ceph.cert_request_pem
  ca_private_key_pem = module.ceph_ca.key
  ca_cert_pem        = module.ceph_ca.certificate

  validity_period_hours = 100*365*24
  early_renewal_hours = 365*24

  allowed_uses = [
    "client_auth",
    "server_auth",
  ]

  is_ca_certificate = false
}