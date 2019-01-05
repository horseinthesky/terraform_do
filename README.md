# Terraform DigitalOcean
Terraform config to deploy DigitalOcean VPS with WireGuard VPN and Telegraf+InfluxDB+Grafana monitoring

## Getting Started

These instructions will create a DigitalOcean droplet with WireGuard server up and running

### Prerequisites

You need to have terraform installed. Find how to do it [here](https://learn.hashicorp.com/terraform/getting-started/install.html).

### Prepare your environment

Create file with DigitalOcean API token and WireGuard server private key in the following format. Make sure there is `secret` in the title and it ends with `.auto.tfvars`. File contents should look like this:
```
do_token = "your_token"
wireguard_private_key = "your_wireguard_server_private_key"
```
Replace my wireguard public keys to yours in `pubkeys` variable in `vars.tf` file and yu are good to go

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
## Setting up monitoring
After terraform finishes its work Telegraf running in container will collect metrics from your VPS host.

Now you are able to open `<your_vps_ip>:3000` in your browser to access Grafana.
Setup login/password and then add InfluxDB data source with URL `http://influxdb:8086` and `telegraf` database.

That's it. You are ready to create your dashboards.
