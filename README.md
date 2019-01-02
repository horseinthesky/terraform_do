# Terraform DigitalOcean
Terraform DigitalOcean VPS config

## Getting Started

These instructions will create a DigitalOcean droplet with WireGuard server up and running

### Prerequisites

You need to have terraform installed

### Prepare your environment

Create file with DigitalOcean API token and WireGuard server private key in the following format. Make sure there is `secret` in the title and it ends with `.auto.tfvars`
```
do_token = "your_token"
wireguard_private_key = "your_wireguard_server_private_key"
```
Replace my wireguard public keys to yours in `pubkeys` variable in `vars.tf` file and yu are good to go
