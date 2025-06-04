output "publicip" {
  value       = azurerm_public_ip.this
  description = <<DESCRIPTION
  * `name` -  Specifies the name of the Public IP.
  * `resource_group_name` - The name of the Resource Group where this Public IP is located.
  * `id` -The ID of this Public IP.
  * `ip_address` - The IP address value that was allocated.
  * `fqdn` -  Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone
  * `sku` - The SKU of the Public IP
Example output:
```
output "name" {
  value = module.module_name.publicip.name
}
```
DESCRIPTION
}
