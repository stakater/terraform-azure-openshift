resource "azurerm_network_security_group" "node" {
  count               = "${var.enable ? 1 : 0}"
  name                = "${var.name}-security-group"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "node" {
  count                       = "${var.enable ? length(var.rules) : 0}"
  name                        = "${var.name}-security-rule-${count.index}"
  priority                    = "${lookup(var.rules[count.index], "priority")}"
  direction                   = "${lookup(var.rules[count.index], "direction")}"
  access                      = "${lookup(var.rules[count.index], "access")}"
  protocol                    = "${lookup(var.rules[count.index], "protocol")}"
  source_port_range           = "*"
  destination_port_range      = "${lookup(var.rules[count.index], "backend_port")}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.node.name}"
}