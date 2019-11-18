resource "null_resource" "public_certificate" {
  provisioner "file" {
    content     = "${var.public_certificate_pem == "" ? "dummy" : var.public_certificate_pem}"
    destination = "~/public_certificate.pem"
  }

  provisioner "file" {
    content     = "${var.public_certificate_key == "" ? "dummy" : var.public_certificate_key}"
    destination = "~/public_certificate.key"
  }

  provisioner "file" {
    content     = "${var.public_certificate_intermediate_pem == "" ? "dummy" : var.public_certificate_intermediate_pem}"
    destination = "~/public_certificate_intermediate.pem"
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }
}
