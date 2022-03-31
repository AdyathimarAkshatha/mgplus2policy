terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
  backend "azurerm" {
  #resource_group_name = "terraform-storage-rg"
  #storage_account_name = "terraformtfstatesa1703"
  #container_name = "tfstatefiles"
  #key = "localtest.tfstate"
  }   

}

provider "azurerm" {
  features {}
}