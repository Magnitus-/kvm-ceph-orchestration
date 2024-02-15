resource "local_file" "ca_cert" {
  content         = module.ceph_ca.certificate
  file_permission = "0600"
  filename        = "${path.module}/../shared/ca.crt"
}

resource "local_file" "server_cert" {
  content         = tls_locally_signed_cert.ceph.cert_pem
  file_permission = "0600"
  filename        = "${path.module}/../shared/server.crt"
}

resource "local_file" "server_key" {
  content         = tls_private_key.ceph.private_key_pem
  file_permission = "0600"
  filename        = "${path.module}/../shared/server.key"
}