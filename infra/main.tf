terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "personal-website"
    storage_account_name = "timmcmanemydotcom"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "e106377b-aa32-40ef-a56f-e590ee3c5359"
  subscription_id = "02f0c3b5-d95a-4be6-9bbb-f0454fae66dd"
}

resource "azurerm_resource_group" "personal_website" {
  name     = "personal-website"
  location = "Central US"
}

resource "azurerm_storage_account" "timmcmanemydotcom" {
  name                     = "timmcmanemydotcom"
  resource_group_name      = azurerm_resource_group.personal_website.name
  location                 = azurerm_resource_group.personal_website.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.timmcmanemydotcom.name
  container_access_type = "private"
}
