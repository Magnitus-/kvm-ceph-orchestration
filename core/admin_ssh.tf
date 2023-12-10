resource "tls_private_key" "admin_ssh" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "local_file" "admin_ssh_private" {
  content         = tls_private_key.admin_ssh.private_key_openssh
  file_permission = "0600"
  filename        = "${path.module}/../shared/ssh_key"
}

resource "local_file" "admin_ssh_public" {
  content         = tls_private_key.admin_ssh.public_key_openssh
  file_permission = "0600"
  filename        = "${path.module}/../shared/ssh_key_public"
}