variable "use_community" {
  default = true
}

variable "platform_name" {
  default = "okd"
}

variable "rhn_username" {}

variable "rhn_password" {}

variable "rh_subscription_pool_id" {}

variable "openshift_major_version" {
  default = "3.11"
}

variable "public_dns_zone_name" {}

variable "public_dns_zone_resource_group" {}

variable "azure_location" {}
variable "azure_resource_group_name" {}
variable "openshift_node_databas_count" {}
variable "openshift_node_verksamhet_count" {}
variable "openshift_master_count" {}
variable "openshift_infra_count" {}
variable "openshift_node_databas_vm_size" {}
variable "openshift_node_verksamhet_vm_size" {}
variable "openshift_master_vm_size" {}
variable "openshift_infra_vm_size" {}
variable "openshift_bastion_vm_size" {}
variable "openshift_master_domain" {}
variable "openshift_router_domain" {}
variable "openshift_os_image_publisher" {}
variable "openshift_os_image_offer" {}
variable "openshift_os_image_sku" {}
variable "openshift_os_image_version" {}
variable "openshift_vm_admin_user" {}

variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_subscription_id" {}
variable "azure_tenant_id" {}

variable "use_certificate" {
  default = false
}

variable "public_certificate_pem" {
  default = ""
}
variable "public_certificate_key" {
  default = ""
}
variable "public_certificate_intermediate_pem" {
  default = ""
}
variable "scale_up" {
  default = false
}
