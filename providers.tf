
terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
  
  subscription_id = "4b988df3-b8e8-49b3-b7bd-a078f8a24d57"
  client_id       = "c220cb0e-7f31-4cb9-a415-8f0687bfe655"
  client_secret   = "jow8Q~kdtE3S9_LPOfLKaVQKaljdVTqHnpt1saqH"
  tenant_id       = "33bc5ab6-4632-439e-8d43-201b74aaa8b3"
}
