data "template_file" "node_config_playbook" {
  template = "${file("${path.module}/provision/node-config-playbook.yaml")}"

  vars {
    openshift_major_version = "${var.openshift_major_version}"
    rhn_username            = "${var.rhn_username}"
    rhn_password            = "${var.rhn_password}"
    rh_subscription_pool_id = "${var.rh_subscription_pool_id}"
    use_community           = "${var.use_community ? "true" : "false"}"
  }
}

data "template_file" "node_config" {
  template = "${file("${path.module}/provision/node-config.sh")}"

  vars {
    platform_name       = "${var.platform_name}"
  }
}

resource "null_resource" "node_config" {
  provisioner "file" {
    content     = "${data.template_file.node_config_playbook.rendered}"
    destination = "~/node-config-playbook.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.node_config.rendered}"
    destination = "~/node-config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/node-config.sh",
      "sh ~/node-config.sh",
    ]
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

  triggers {
    inventory = "${data.template_file.node_config_playbook.rendered}"
  }

  depends_on = [
    "null_resource.bastion_config",
    "null_resource.template_inventory", 
    "module.node_master", 
    "module.node_infra",
    "module.node_databas",
    "module.node_verksamhet",
    "azurerm_dns_a_record.master"
  ]
}
