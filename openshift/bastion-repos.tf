data "template_file" "bastion_repos" {
  template = "${file("${path.module}/provision/bastion-repos.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "null_resource" "bastion_repos" {
  provisioner "file" {
    content     = "${data.template_file.bastion_repos.rendered}"
    destination = "~/bastion-repos.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bastion-repos.sh",
      "export USE_COMMUNITY=${var.use_community ? "true" : ""}",
      "sh ~/bastion-repos.sh",
    ]
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

  triggers {
    script = "${data.template_file.bastion_repos.rendered}"
  }

  depends_on = ["module.node_bastion"]
}
