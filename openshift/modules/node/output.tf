output "load_balancer_id" {
  value = "${module.scaling.lb_id}"
}

output "ip_address" {
  value = "${module.public_ip.ip_address}"
}

output "fqdn" {
  value = "${module.public_ip.fqdn}"
}