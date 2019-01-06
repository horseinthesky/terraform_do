variable "do_token" {}
variable "wireguard_private_key" {}
variable "grafana_admin_password" {
  description = "Grafana admin password"
  default = "admin"
}
variable "pubkeys" {
  description = "WireGuard clients pubkeys"
  default = [
    "4zEi1zL93NoTfbJV84sTiscv1xXO8o+MNMx9pTrhjzw=",
    "62Gws13zn1KTgjJZ126sT1M6aqu2QDIRqO9w7htZ7zU=",
    "rNHG0AL1LUZsnQPpxdUBjUs/YspgtWgV+N/ytk/YyGo="
  ]
}
