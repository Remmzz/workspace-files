output "dev_website_endpoint" {
  value= "http://${azurerm_storage_account.storage.name}.blob.core.windows.net/index.html"
}
