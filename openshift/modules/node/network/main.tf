resource "azurerm_subnet" "node" {
  name                 = "${var.name}-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.subnet_address_prefix}"
}

resource "azurerm_network_interface" "node_public_single" {
  count                     = "${var.expose_node && !var.enable_scaling ? 1 : 0}"
  name                      = "${var.name}-nic-${count.index + 1}"
  location                  = "${var.azure_location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = "${var.ip_address_id}"
    subnet_id                     = "${azurerm_subnet.node.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "node_public_multiple" {
  count               = "${var.expose_node && var.enable_scaling ? var.node_count : 0}"
  name                = "${var.name}-nic-${count.index + 1}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                                    = "default"
    load_balancer_backend_address_pools_ids = ["${var.lb_backend_address_pool_id}"]
    subnet_id                               = "${azurerm_subnet.node.id}"
    private_ip_address_allocation           = "dynamic"
  }
}

resource "azurerm_network_interface" "node_private_single" {
  count               = "${!var.expose_node && !var.enable_scaling ? 1 : 0}"
  name                = "${var.name}-nic-${count.index + 1}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                          = "default"
    subnet_id                     = "${azurerm_subnet.node.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "node_private_multiple" {
  count               = "${!var.expose_node && var.enable_scaling ? var.node_count : 0}"
  name                = "${var.name}-nic-${count.index + 1}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                          = "default"
    subnet_id                     = "${azurerm_subnet.node.id}"
    private_ip_address_allocation = "dynamic"
  }
}
