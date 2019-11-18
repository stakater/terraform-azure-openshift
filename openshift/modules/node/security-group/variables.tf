variable "name" {
  default = "node"
}

variable "enable" {}

variable "azure_location" {}

variable "resource_group_name" {}

variable "rules" {
  type = "list"
}
