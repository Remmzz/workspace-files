terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
 
data "azurerm_client_config" "current" {}

# Assign random pet names to resource groups
resource "random_pet" "petname" {
  length    = 4
  separator = "-"
}
 
#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${random_pet.petname.id}"
  location = var.location
}
 
#Create Storage account
resource "azurerm_storage_account" "storage" {
  name                = "${var.prefix}examplestorage"
  resource_group_name = azurerm_resource_group.rg.name
 
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
 
  static_website {
    index_document = "index.html"
  }
}
 
#Add index.html to blob storage
resource "azurerm_storage_blob" "blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}
