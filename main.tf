resource "digitalocean_droplet" "foobar" {
  name   = var.vm_name
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  region = "nyc3"
  vpc_uuid = digitalocean_vpc.vpc1.id
  ssh_keys = [digitalocean_ssh_key.public_key.id]
}

resource "digitalocean_project" "playground" {
  name        = var.project_name
  description = "A project to complete task1 from TF training."
  purpose     = "VM creation"
  environment = "Development"
  resources   = [digitalocean_droplet.foobar.urn]
}

resource "digitalocean_ssh_key" "public_key" {
  name       = "example-key-pk"
  public_key = tls_private_key.name.public_key_openssh
}

resource "tls_private_key" "name" {
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  content  = tls_private_key.name.private_key_openssh
  filename = "${path.module}/priv.key"
  file_permission = "0600"
}

resource "digitalocean_vpc" "vpc1" {
  name   = var.vpc_name
  region = "nyc3"
}

resource "digitalocean_firewall" "ssh2" {
  name = "only-ssh"

  droplet_ids = [digitalocean_droplet.foobar.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.src_addr]#["0.0.0.0/0", "::/0"]
  }


}