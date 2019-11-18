data "template_file" "scale_up" {
  template = "${file("${path.module}/provision/scale-up.sh")}"

}

resource "null_resource" "scale_up" {
  
  count = "${var.scale_up ? 1 : 0}"

  provisioner "file" {
    content     = "${data.template_file.node_config_playbook.rendered}"
    destination = "~/node-config-playbook.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.scale_up.rendered}"
    destination = "~/scale-up.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/scale-up.sh",
      "tmux new-session -d -s scaleUp ~/scale-up.sh",
      "sleep 1",                                                  # https://stackoverflow.com/questions/36207752/how-can-i-start-a-remote-service-using-terraform-provisioning
    ]
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

}
