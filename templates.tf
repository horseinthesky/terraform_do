data "template_file" "peer" {
  count = "${length(var.pubkeys)}"
  template = "${file("${path.module}/config_templates/peer.tpl")}"
  vars {
    index = "${count.index + 2}"
    pubkey = "${element(var.pubkeys, count.index)}"
  }
}
data "template_file" "server" {
  template = "${file("${path.module}/config_templates/server.tpl")}"
  vars {
    private_key = "${var.wireguard_private_key}"
    peers = "${join("\n", data.template_file.peer.*.rendered)}"
  }
}
