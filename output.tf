output "instance_ip_addr" {
  value = azurerm_linux_virtual_machine.virtualmachine.public_ip_addresses
}
