resource "azurerm_resource_group" "example" {
  name     = "rg-pip-example"
  location = "germanywestcentral"
}

module "public_ip" {
  source                  = "../../"
  name                    = "pip-example"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  allocation_method       = "Static"
  zones                   = ["1"]
  ddos_protection_mode    = "Disabled"
  domain_name_label       = "my-public-ip"
  idle_timeout_in_minutes = 10
  ip_version              = "IPv4"
  sku                     = "Standard"
  sku_tier                = "Regional"

  tags = {
    Environment = "Production"
    Owner       = "Your Name"
  }
}
