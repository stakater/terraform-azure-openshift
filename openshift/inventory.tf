data "template_file" "template_inventory" {
  template = "${file("${path.module}/provision/template-inventory.yaml")}"

  vars {
    platform_name                   = "${var.platform_name}"
    platform_domain                 = "${var.openshift_router_domain}"
    master_domain                   = "${var.openshift_master_domain}"
    ansible_user                    = "${var.openshift_vm_admin_user}"
    rhn_username                    = "${var.rhn_username}"
    rhn_password                    = "${var.rhn_password}"
    rh_subscription_pool_id         = "${var.rh_subscription_pool_id}"
    openshift_deployment_type       = "${var.use_community ? "origin" : "openshift-enterprise"}"
    openshift_major_version         = "${var.openshift_major_version}"
    openshift_repos_enable_testing  = "${var.use_community ? "true" : "false"}"
    use_allow_all_identity_provider = false
    azure_client_id                 = "${var.azure_client_id}"
    azure_client_secret             = "${var.azure_client_secret}"
    azure_resource_group            = "${var.azure_resource_group_name}"
    azure_subscription_id           = "${var.azure_subscription_id}"
    azure_tenant_id                 = "${var.azure_tenant_id}"
    azure_location                  = "${var.azure_location}"

    named_certificate               = "${var.use_certificate ? true : false}"
    
  }
}

resource "null_resource" "template_inventory" {
  provisioner "file" {
    content     = "${data.template_file.template_inventory.rendered}"
    destination = "~/inventory.yaml"
  }

  connection {
    type        = "ssh"
    host        = "${module.node_bastion.ip_address}"
    user        = "${var.openshift_vm_admin_user}"
    private_key = "${file("${path.module}/../keys/bastion.key")}"
  }

  triggers {
    template_inventory = "${data.template_file.template_inventory.rendered}"
  }

  depends_on = ["null_resource.bastion_config"]
}
