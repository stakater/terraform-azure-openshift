resource "azurerm_availability_set" "node" {
  count               = "${var.enable ? 1 : 0}"
  name                = "${var.name}-availability-set"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  managed             = true
}

resource "azurerm_lb" "node" {
  count               = "${var.enable ? 1 : 0}"
  name                = "${var.name}-load-balancer"
  location            = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "default"
    public_ip_address_id          = "${var.ip_address_id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "node" {
  count               = "${var.enable ? 1 : 0}"
  name                = "${var.name}-address-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.node.id}"
}

resource "azurerm_lb_rule" "node" {
  count                          = "${var.enable ? length(var.rules): 0}"
  name                           = "${var.name}-lb-rule-${count.index}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.node.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.node.id}"
  protocol                       = "${lookup(var.rules[count.index], "protocol")}"
  frontend_port                  = "${lookup(var.rules[count.index], "frontend_port")}"
  backend_port                   = "${lookup(var.rules[count.index], "backend_port")}"
  frontend_ip_configuration_name = "default"
}
