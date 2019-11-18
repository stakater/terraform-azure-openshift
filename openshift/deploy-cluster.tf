data "template_file" "deploy_cluster" {
  template = "${file("${path.module}/provision/deploy-cluster.sh")}"

  vars {
    platform_name           = "${var.platform_name}"
    openshift_major_version = "${var.openshift_major_version}"
  }
}

resource "null_resource" "main" {
  provisioner "file" {
    content     = "${data.template_file.deploy_cluster.rendered}"
    destination = "~/deploy-cluster.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/deploy-cluster.sh",
      "tmux new-session -d -s deploycluster ~/deploy-cluster.sh",
      "sleep 1",                                                  # https://stackoverflow.com/questions/36207752/how-can-i-start-a-remote-service-using-terraform-provisioning
    ]
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

  triggers {
    inventory = "${data.template_file.template_inventory.rendered}"
    installer = "${data.template_file.deploy_cluster.rendered}"
  }

  depends_on = [
    "null_resource.node_config",
    "null_resource.template_inventory"
  ]
}
