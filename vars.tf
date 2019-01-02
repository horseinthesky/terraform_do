variable "do_token" {}
variable "wireguard_private_key" {}
variable "pvt_key" {
  description = "Private SSH key"
  default = "~/.ssh/id_rsa"
}
variable "ssh_fingerprint" {
  description = "SSH pubkey fingerprint"
  default = "bc:e3:1b:12:4e:1c:53:c1:48:a4:34:b4:74:5f:41:0e"
}
variable "pubkeys" {
  default = [
    "4zEi1zL93NoTfbJV84sTiscv1xXO8o+MNMx9pTrhjzw=",
    "62Gws13zn1KTgjJZ126sT1M6aqu2QDIRqO9w7htZ7zU=",
    "rNHG0AL1LUZsnQPpxdUBjUs/YspgtWgV+N/ytk/YyGo="
  ]
}
