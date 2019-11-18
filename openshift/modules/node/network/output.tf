output "subnet_id" {
  value = "${azurerm_subnet.node.id}"
}

output "network_interface_ids" {
  value = "${var.expose_node ? (var.enable_scaling ? join(",", azurerm_network_interface.node_public_multiple.*.id) : join(",", azurerm_network_interface.node_public_single.*.id) ): (var.enable_scaling ? join(",", azurerm_network_interface.node_private_multiple.*.id) : join(",", azurerm_network_interface.node_private_single.*.id)) }"
}