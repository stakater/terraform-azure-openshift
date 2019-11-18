output "bastion_public_ip" {
  value = "${module.node_bastion.ip_address}"
}

output "console_public_ip" {
  value = "${module.node_master.ip_address}"
}

output "console_public_fqdn" {
  value = "${module.node_master.fqdn}"
}

output "router_public_ip" {
  value = "${module.node_infra.ip_address}"
}

output "master_count" {
  value = "${var.openshift_master_count}"
}

output "infra_count" {
  value = "${var.openshift_infra_count}"
}

output "admin_user" {
  value = "${var.openshift_vm_admin_user}"
}

output "master_domain" {
  value = "${var.openshift_master_domain}"
}

output "router_domain" {
  value = "${var.openshift_router_domain}"
}
