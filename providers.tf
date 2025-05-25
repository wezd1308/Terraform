terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  /* Ajustar a la version que necesites */
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

/*
provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "my-gcp-project"
  region  = "us-central1"
}
*/
