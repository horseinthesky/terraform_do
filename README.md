# Terraform DigitalOcean
Terraform config to deploy DigitalOcean VPS with WireGuard VPN and Telegraf+InfluxDB+Grafana monitoring

## Getting Started

These instructions will create a DigitalOcean droplet with WireGuard server up and running

### Prerequisites

You need to have terraform installed. Find the instructions [here](https://learn.hashicorp.com/terraform/getting-started/install.html).

### Prepare your secrets

Create a secrets file with DigitalOcean API token and WireGuard server private key in the following format:
```
do_token = "your_token"
wireguard_private_key = "your_wireguard_server_private_key"
```
You may also provide `grafana_admin_password` variable in secrets file. Otherwise `admin` user password will be `admin`.
Make sure there is `secret` in the title and it ends with `.auto.tfvars`.

### Specify your WireGuard clients pubkeys
Replace my wireguard public keys(`pubkeys` variable) with yours in `vars.tf` file and you are good to go.

## Deployment
Download the plugins needed
```
terraform init
```
Make a plan
```
terraform plan
```
Deploy VPS
```
terraform apply
```
## What you'll get
### WireGuard
WireGuard up and waiting for your connections. Server tunnel IP is `192.168.255.1`.
For every pubkey there will be peer configured with IP from subnet `192.168.255.x/24` starting with `2`.

### Monitoring
Monitoring service will run Telegraf+InfluxDB+Grafana with [docker-compose](https://docs.docker.com/compose/).
Telegraf running in container will collect metrics from host system and store it in `telegraf` InfluxDB database.
Grafana will be already configured with provided `admin` user password, connected to InfluxDB database and [this](https://grafana.com/dashboards/5955) dashboard set.
Enter `<your_vps_ip>:3000` in your browser to access Grafana.
