resource "azurerm_resource_group" "example" {
  name     = "rg-pip-example"
  location = "germanywestcentral"
}

module "public_ip" {
  source              = "../../"
  name                = "pip-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}
