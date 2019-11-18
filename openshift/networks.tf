resource "azurerm_virtual_network" "openshift" {
  name          = "openshift-virtual-network"
  address_space = ["10.0.0.0/16"]
  location      = "${var.azure_location}"
  resource_group_name = "${azurerm_resource_group.openshift.name}"
}

resource "azurerm_dns_zone" "openshift" {
  name                              = "openshift.local"
  resource_group_name               = "${azurerm_resource_group.openshift.name}"
  zone_type                         = "Private"
  registration_virtual_network_ids  = ["${azurerm_virtual_network.openshift.id}"]
}
