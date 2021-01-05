provider "azurerm" {
  features {}
}
locals {
 data_set = csvdecode(file("${path.module}/csvforteeraform.csv"))
}
resource "azurerm_resource_group" "name" {
 for_each = { for inst in local.data_set : inst.local_id => inst }
 name = each.value.name
 location = each.value.location
}
