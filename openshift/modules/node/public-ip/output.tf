output "id" {
  value = "${join(",", azurerm_public_ip.node.*.id)}"
}

output "ip_address" {
  value = "${join(",", azurerm_public_ip.node.*.ip_address)}"
}

output "fqdn" {
  value = "${join(",", azurerm_public_ip.node.*.fqdn)}"
}
