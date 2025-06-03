resource "azurerm_resource_group" "resource_group_wezdrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage_account_wezdsa" {
  name                     = var.storageaccount
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }

  depends_on = [azurerm_resource_group.resource_group_wezdrg]
}

resource "azurerm_storage_share" "file_share" {
  name                 = var.file_share
  storage_account_name = azurerm_storage_account.storage_account_wezdsa.name
  quota                = 50

  depends_on = [azurerm_storage_account.storage_account_wezdsa]
}

resource "azurerm_storage_share_file" "file" {
  name             = "prueba.txt"
  storage_share_id = azurerm_storage_share.file_share.id

  depends_on = [azurerm_storage_share.file_share]
}

resource "azurerm_storage_sync" "file_sync" {
  name                = var.file_sync
  resource_group_name = var.resource_group_name
  location            = var.location

  depends_on = [azurerm_resource_group.resource_group_wezdrg]
}

resource "azurerm_storage_sync_group" "sync_group" {
  name            = var.sync_group
  storage_sync_id = azurerm_storage_sync.file_sync.id

  depends_on = [azurerm_storage_sync.file_sync]
}
