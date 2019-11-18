module "public_ip" {
  source = "public-ip"

  name                = "${var.name}"
  enable              = "${var.expose_node}"
  azure_location      = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  platform_name       = "${var.platform_name}"
}

module "network" {
  source = "network"

  name                       = "${var.name}"
  azure_location             = "${var.azure_location}"
  resource_group_name        = "${var.resource_group_name}"
  virtual_network_name       = "${var.network_name}"
  expose_node                = "${var.expose_node}"
  enable_scaling             = "${var.enable_scaling}"
  node_count                 = "${var.count}"
  subnet_address_prefix      = "${var.subnet_address_prefix}"
  lb_backend_address_pool_id = "${module.scaling.lb_backend_address_pool_id}"
  ip_address_id              = "${module.public_ip.id}"
  security_group_id          = "${module.security-group.id}"
}

resource "azurerm_storage_container" "node" {
  count                 = "${var.count}"
  name                  = "${var.name}-${count.index + 1}"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${var.storage_account_name}"
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "node" {
  count                 = "${var.count}"
  name                  = "${var.name}${count.index + 1}"
  location              = "${var.azure_location}"
  resource_group_name   = "${var.resource_group_name}"
  availability_set_id   = "${module.scaling.availability_set_id}"
  network_interface_ids = ["${element(split(",", module.network.network_interface_ids), count.index)}"]
  vm_size               = "${var.size}"

  storage_image_reference {
    publisher = "${var.os_image_publisher}"
    offer     = "${var.os_image_offer}"
    sku       = "${var.os_image_sku}"
    version   = "${var.os_image_version}"
  }

  storage_os_disk {
    name              = "${var.name}-vm-os-disk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.name}-vm-data-disk-${count.index + 1}"
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    lun               = 0
    disk_size_gb      = 20
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "${var.name}${count.index + 1}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.key_data}"
    }
  }

  depends_on = ["module.network"]
}

module "scaling" {
  source = "scaling"

  enable              = "${var.enable_scaling}"
  name                = "${var.name}"
  azure_location      = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  rules               = "${var.rules}"
  ip_address_id       = "${module.public_ip.id}"
}

module "security-group" {
  source = "security-group"

  enable              = "${length(var.rules) > 0}"
  name                = "${var.name}"
  azure_location      = "${var.azure_location}"
  resource_group_name = "${var.resource_group_name}"
  rules               = "${var.rules}"
}
