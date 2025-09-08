provider "azurerm" {
  features {}
  subscription_id = "55f702f9-17ee-4d42-8da3-3f0bc97c4158"
}

data "azurerm_resource_group" "rg_info" {
  name = var.resource_group_name
}
module "azurerm_windows_web_app" {
  source               = "git::https://github.com/AAInternal/terraform.git//azure-modules/windows_web_app?ref=windows_web_app-v1.0.0"
  appservice_plan_name = var.appservice_plan_name
  resource_group_name  = var.resource_group_name
  appservice_os_type   = var.appservice_os_type
  appservice_sku_name  = var.appservice_sku_name

  appservice = {
    appservice-1 = {
      appservice_name = var.webapp_name
      appservice_plan_id = var.appservice_plan_id
      site_config = [{
        ftps_state    = var.ftps_state
        always_on     = var.always_on
      }]
    }
 }      
}
