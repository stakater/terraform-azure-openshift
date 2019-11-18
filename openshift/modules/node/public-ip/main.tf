resource "random_string" "node" {
  length  = 16
  special = false
  upper   = false
}

resource "azurerm_public_ip" "node" {
  count                        = "${var.enable ? 1 : 0}"
  name                         = "${var.name}-public-ip"
  location                     = "${var.azure_location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.platform_name}-${random_string.node.result}"
  sku                          = "Standard"
}