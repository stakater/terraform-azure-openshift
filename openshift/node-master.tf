module "node_master" {
  source = "modules/node"

  name                  = "master"
  count                 = "${var.openshift_master_count}"
  expose_node           = true
  enable_scaling        = true
  size                  = "${var.openshift_master_vm_size}"
  azure_location        = "${var.azure_location}"
  resource_group_name   = "${azurerm_resource_group.openshift.name}"
  storage_account_name  = "${azurerm_storage_account.openshift.name}"
  network_name          = "${azurerm_virtual_network.openshift.name}"
  subnet_address_prefix = "10.0.1.0/24"
  key_data              = "${file("${path.module}/../keys/openshift.pub")}"
  os_image_publisher    = "${var.openshift_os_image_publisher}"
  os_image_offer        = "${var.openshift_os_image_offer}"
  os_image_sku          = "${var.openshift_os_image_sku}"
  os_image_version      = "${var.openshift_os_image_version}"
  admin_username        = "${var.openshift_vm_admin_user}"
  platform_name         = "${var.platform_name}"

  rules = [
    {
      protocol      = "tcp"
      frontend_port = 8443
      backend_port  = 8443
      priority      = 100
      access        = "Allow"
      direction     = "Inbound"
    }
  ]
}

resource "azurerm_dns_a_record" "master" {
  name                = "master"
  zone_name           = "${var.public_dns_zone_name}"
  resource_group_name = "${var.public_dns_zone_resource_group}"
  ttl                 = 300
  records             = ["${module.node_master.ip_address}"]
}

resource "azurerm_dns_a_record" "openshift" {
  name                = "@"
  zone_name           = "${var.public_dns_zone_name}"
  resource_group_name = "${var.public_dns_zone_resource_group}"
  ttl                 = 300
  records             = ["${module.node_master.ip_address}"]
}

resource "azurerm_lb_probe" "master" {
  name                = "master-lb-probe-8443-up"
  resource_group_name = "${azurerm_resource_group.openshift.name}"
  loadbalancer_id     = "${module.node_master.load_balancer_id}"
  protocol            = "Https"
  request_path        = "/healthz"
  port                = 8443
}
