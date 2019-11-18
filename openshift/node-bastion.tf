module "node_bastion" {
  source = "modules/node"

  name                  = "bastion"
  count                 = "1"
  expose_node           = true
  enable_scaling        = false
  size                  = "${var.openshift_bastion_vm_size}"
  azure_location        = "${var.azure_location}"
  resource_group_name   = "${azurerm_resource_group.openshift.name}"
  storage_account_name  = "${azurerm_storage_account.openshift.name}"
  network_name          = "${azurerm_virtual_network.openshift.name}"
  subnet_address_prefix = "10.0.0.0/24"
  key_data              = "${file("${path.module}/../keys/bastion.pub")}"
  os_image_publisher    = "${var.openshift_os_image_publisher}"
  os_image_offer        = "${var.openshift_os_image_offer}"
  os_image_sku          = "${var.openshift_os_image_sku}"
  os_image_version      = "${var.openshift_os_image_version}"
  admin_username        = "${var.openshift_vm_admin_user}"
  platform_name         = "${var.platform_name}"

  rules = [
    {
      protocol      = "tcp"
      frontend_port = "*"
      backend_port  = 22
      priority      = 100
      access        = "Allow"
      direction     = "Inbound"
    }
  ]
}
