output "id" {
  value = "${join(",", azurerm_network_security_group.node.*.id)}"
}
