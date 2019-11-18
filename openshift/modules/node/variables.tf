variable "name" {
  default = "node"
}

variable "platform_name" {}

variable "count" {}

variable "expose_node" {}

variable "enable_scaling" {}

variable "size" {}

variable "azure_location" {}

variable "resource_group_name" {}

variable "storage_account_name" {}

variable "network_name" {}

variable "subnet_address_prefix" {
  description = "Subnet address prefix range"
}

variable "rules" {
  type = "list"
  default = []
}

variable "key_data" {}


variable "os_image_publisher" {}

variable "os_image_offer" {}

variable "os_image_sku" {}

variable "os_image_version" {}

variable "admin_username" {}
