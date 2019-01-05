output "VPS public ip" {
  value = "${digitalocean_droplet.vps.ipv4_address}"
}
