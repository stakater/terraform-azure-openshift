data "template_file" "bastion_config_playbook" {
  template = "${file("${path.module}/provision/bastion-config-playbook.yaml")}"

  vars {
    openshift_major_version = "${var.openshift_major_version}"
  }
}

data "template_file" "bastion_config" {
  template = "${file("${path.module}/provision/bastion-config.sh")}"
}

resource "null_resource" "bastion_config" {
  provisioner "file" {
    content     = "${data.template_file.bastion_config_playbook.rendered}"
    destination = "~/bastion-config-playbook.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.bastion_config.rendered}"
    destination = "~/bastion-config.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../keys/openshift.key"
    destination = "~/openshift.key"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 ~/openshift.key",
      "chmod +x ~/bastion-config.sh",
      "sh  ~/bastion-config.sh",
    ]
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

  triggers {
    playbook = "${data.template_file.bastion_config_playbook.rendered}"
  }

  depends_on = ["null_resource.bastion_repos"]
}
