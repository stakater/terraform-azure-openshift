output "availability_set_id" {
  value = "${join(",", azurerm_availability_set.node.*.id)}"
}

output "lb_id" {
  value = "${join(",", azurerm_lb.node.*.id)}"
}

output "lb_backend_address_pool_id" {
  value = "${join(",", azurerm_lb_backend_address_pool.node.*.id)}"
}
