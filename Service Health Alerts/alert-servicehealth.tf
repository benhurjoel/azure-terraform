provider "azurerm" {
  subscription_id = "xxxxx-xxxxx-xxxxx"
  features {}
}

resource "azurerm_resource_group" "rg" {
    name =  "demo-dev-rg-01"
    location = "<your_preferred_region>"
  
}

resource "azurerm_storage_account" "sa1" {
  name                     = "<please read Azure Storage Account naming rules>"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_action_group" "ag1" {
  name                = "demo-dev-ag-servicehealth-01"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "servicedownalert"
  
  email_receiver {
    name          = "demo-dev-alert-email-01"
    email_address = "youremail@domain"
  }

}


resource "azurerm_template_deployment" "alert1" {
  name                = "demo-deployment-01"
  resource_group_name = azurerm_resource_group.rg.name
  
  template_body       = file("alert-servicehealth.json")
  parameters = {
    "name"                      = "demo-dev-alert-servicehealth-01"
    "actionGroups_name"         = azurerm_monitor_action_group.ag1.name
   
     }
  deployment_mode = "Incremental"

}
