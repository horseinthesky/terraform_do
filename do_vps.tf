resource "digitalocean_droplet" "vps" { # terraform name
  image = "ubuntu-18-04-x64"
  name = "VPS" # DO name
  region = "fra1"
  size = "s-1vcpu-2gb"
  monitoring = true
  ipv6 = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }

  # Allow forwarding in the host
  provisioner "remote-exec" {
    inline = [
      "sed -i -r 's/^#.*_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf",
      "sed -i -r 's/^#.*[.]forward.*/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf",
      "sysctl -p",
      "echo 1 > /proc/sys/net/ipv4/ip_forward",
      "echo 1 > /proc/sys/net/ipv6/conf/all/forwarding"
    ]
  }

  # Install WireGuard
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "add-apt-repository -y ppa:wireguard/wireguard",
      "apt-get update",
      "apt-get install -y wireguard"
    ]
  }

  # Generate WireGuard config file
  provisioner "file" {
    content = "${data.template_file.server.rendered}"
    destination = "/etc/wireguard/wg0.conf"
  }

  # Enable WireGuard interface on startup
  provisioner "remote-exec" {
    inline = [
      "systemctl enable wg-quick@wg0",
      "systemctl start wg-quick@wg0"
    ]
  }

  # Install Docker and Docker-compose
  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common python3-pip",
      "apt-get install -y docker.io",
      "apt autoremove -y",
      "pip3 install -U pip",
      "pip install docker-compose"
    ]
  }
}
