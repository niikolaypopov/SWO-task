#Generating and storing locally private key for instances
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive=true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
  sensitive=true
}

resource "aws_key_pair" "my-key-pair" {
  key_name = "nn-terraform"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "key" {
  filename = "./nn-terraform.pem"
  content = tls_private_key.ssh_key.private_key_pem
}