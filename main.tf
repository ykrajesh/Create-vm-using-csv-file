provider "azurerm" {
  features {}
}
locals {
 data_set = csvdecode(file("${path.module}/csvforteeraform.csv"))
}
########## Create resource group #############
resource "azurerm_resource_group" "rg" {
 for_each = { for inst in local.data_set : inst.local_id => inst }
 name = each.value.rgname
 location = each.value.location
}
################## create virtual network  ######################
resource "azurerm_virtual_network" "Vnet" {
  for_each = { for inst in local.data_set : inst.local_id => inst }
  name                = each.value.vnet
  address_space       = ["10.0.0.0/16"]
  location            = each.value.location
  resource_group_name = each.value.rgname
}
################## create Subnet ######################
resource "azurerm_subnet" "Subnet" {
  for_each = { for inst in local.data_set : inst.local_id => inst }
  name                 = each.value.subnet
  resource_group_name  = each.value.rgname
  virtual_network_name = each.value.vnet
  address_prefixes     = ["10.0.2.0/24"]
}
################## NIC create  ######################
/*
resource "azurerm_network_interface" "nic" {
  for_each = { for inst in local.data_set : inst.local_id => inst }
  name                = each.value.nicname
  location            = each.value.location
  resource_group_name = each.value.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
*/