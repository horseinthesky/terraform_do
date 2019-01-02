data "template_file" "ansible_hosts" {
  template = "${file("${path.module}/config_templates/hosts.tpl")}"
  vars {
    public_ip = "${digitalocean_droplet.vps.ipv4_address}"
  }
}

output "Public ip" {
  value = "${data.template_file.ansible_hosts.rendered}"
}
