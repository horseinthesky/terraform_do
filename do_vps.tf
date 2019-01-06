# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "Default"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "vps" {
  image = "ubuntu-18-04-x64"
  name = "VPS"
  region = "fra1"
  size = "s-1vcpu-2gb"
  monitoring = true
  ipv6 = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.fingerprint}"
  ]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
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
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common python3-pip",
      "apt-get install -y docker.io",
      "apt autoremove -y",
      "pip3 install -U pip",
      "pip install docker-compose"
    ]
  }

  # Copy monitoring stuff
  provisioner "file" {
    source = "monitoring"
    destination = "/opt"
  }

  # Install monitoring
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /srv/influxdb/data",
      "mkdir -p /srv/grafana/data; chown 472:472 /srv/grafana/data",
      "mv /opt/monitoring/monitoring.service /etc/systemd/system/monitoring.service",
      "systemctl daemon-reload",
      "systemctl enable monitoring.service",
      "systemctl start monitoring.service"
    ]
  }

  # Setup Grafana
  provisioner "remote-exec" {
    inline = [
      "curl -X POST -u admin:admin -H 'Content-Type: application/json' -d @/opt/monitoring/datasource.json http://localhost:3000/api/datasources",
      "curl -X POST -u admin:admin -H 'Content-Type: application/json' -d @/opt/monitoring/dashboard.json http://localhost:3000/api/dashboards/db",
      "curl -X PUT -u admin:admin -H 'Content-Type: application/json' -d '{\"password\": \"${var.grafana_admin_password}\"}' http://localhost:3000/api/admin/users/1/password"
    ]
  }
}
