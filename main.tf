provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  use_oidc = true
}

terraform {
  
  required_version = ">= 1.2.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth     = true
    use_oidc             = true
    storage_account_name = "@@STORAGE_ACCOUNT_NAME@@"
    resource_group_name  = "@@RESOURCE_GROUP_NAME@@"
    container_name       = "terraform"
    key                  = "gaaseastaa.terraform.tfstate"
  }
}

module "policy_definitions" {
  display_name_prefix = var.display_name_prefix
  environment         = var.environment
  management_group_id = var.management_group_id
  name_suffix         = var.name_suffix
  path_to_policies    = "./azure/policies"
  source              = "./components/policy/definitions"
}

module "policy_assignments" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_policies    = "./azure/policies"
  policy_ids          = module.policy_definitions.ids
  source              = "./components/policy/assignments"
}

module "policy_initiatives" {
  display_name_prefix = var.display_name_prefix
  environment         = var.environment
  management_group_id = var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "./azure/initiatives"
  policy_ids          = module.policy_definitions.ids
  source              = "./components/initiative/definitions"
}

module "policy_initiative_assignments" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_initiatives = "./azure/initiatives"
  policy_ids          = module.policy_initiatives.ids
  source              = "./components/initiative/assignments"
}

module "policy_exemption" {
  ex_fileset_filter   = var.ex_fileset_filter
  display_name_prefix = var.display_name_prefix
  name_suffix         = var.name_suffix
  source              = "./components/policy/exemption"
}
