locals {
  production = "Prod"
}

module "enforce_aa_standard_tags" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Enforce AA Standard Tags on Resource Groups"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.enforce_aa_sdlc
      parameter_values = jsonencode(jsondecode(file("${var.path_to_def}/tags/Enforce AA Standard Tags on Resource Groups/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.enforce_aa_app_shortname
      parameter_values = jsonencode(jsondecode(file("${var.path_to_def}/tags/Enforce AA Standard Tags on Resource Groups/policyset.json")).properties.policyDefinitions[1].parameters)
    },
  ]
  source = "../../definitions/initiative"
}

module "initiative_inherit_tags_from_RG2Resources" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.inherit_tags_from_RG2Resources
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.inherit_tags_from_RG2Resources
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources/policyset.json")).properties.policyDefinitions[1].parameters)
    },
  ]
  source = "../../definitions/initiative"
}

module "initiative_inherit_tags_from_RG2Resources_flex" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.inherit_tags_from_RG2Resources_flex
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.inherit_tags_from_RG2Resources
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.inherit_tags_from_RG2Resources_flex
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility/policyset.json")).properties.policyDefinitions[2].parameters)
    },
  ]
  source = "../../definitions/initiative"
}

module "initiative_enforce_aa_standard_tag_values_on_resources" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Enforce Valid AA Standard Tag Values on Resources"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.enforce_aa_app_shortname_tag_value_on_resources
      parameter_values = jsonencode(jsondecode(file("${var.path_to_def}/tags/Enforce Valid AA Standard Tag Values on Resources/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.enforce_aa_sdlc_environment_tag_value_on_resources
      parameter_values = jsonencode(jsondecode(file("${var.path_to_def}/tags/Enforce Valid AA Standard Tag Values on Resources/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "intitiative_audit_sa_encryption" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/storage-accounts/Audit Storage Account Encryption Type"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.audit_sa_encryption
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/storage-accounts/Audit Storage Account Encryption Type/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_sa_encryption
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/storage-accounts/Audit Storage Account Encryption Type/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "intitiative_audit_sql_server_tde" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/database-services/azure-sql-database/Audit SQL Server Transparent Data Encryption Type"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.audit_sql_server_tde
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Audit SQL Server Transparent Data Encryption Type/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_sql_server_tde
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Audit SQL Server Transparent Data Encryption Type/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_audit_webapp_java_version" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/app-services/Audit WebApp Java Version"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.audit_webapp_java_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Java Version/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_webapp_slot_java_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Java Version/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_storage_account_service_logs" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_storage_account_service_logs
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Storage Accounts Service Logs Initiative/policyset.json")).properties.policyDefinitions[6].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_audit_webapp_python_version" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/app-services/Audit WebApp Python Version"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.audit_webapp_python_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Python Version/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_webapp_slot_python_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Python Version/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_audit_webapp_php_version" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/app-services/Audit WebApp Php Version"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.audit_webapp_php_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Php Version/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_webapp_slot_php_version
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/app-services/Audit WebApp Php Version/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_webapp_httplogs_log_to_eventhub" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_webapp_httplogs_log_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[5].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_nsg_flow_logs" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_nsg_flow_logs_90_day
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Network Security Group Flow Logs/policyset.json")).properties.policyDefinitions[6].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_key_vault_logs_to_eventhub" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_key_vault_logs_to_eventhub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[6].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_modify_rg_aa_criticality_tag_value" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Modify auto tag ResourceGroups with aa-criticality tag"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.modify_rg_aa_criticality_tag_value_vital
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag ResourceGroups with aa-criticality tag/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_rg_aa_criticality_tag_value_critical
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag ResourceGroups with aa-criticality tag/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_rg_aa_criticality_tag_value_important
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag ResourceGroups with aa-criticality tag/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_rg_aa_criticality_tag_value_discretionary
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag ResourceGroups with aa-criticality tag/policyset.json")).properties.policyDefinitions[3].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_function_app_logs_to_evhub_linux" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[6].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_function_app_logs_to_evhub_windows" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_function_app_logs_to_eventhub_os
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub/policyset.json")).properties.policyDefinitions[6].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_modify_resource_aa_criticality_tag_value" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/tags/Modify auto tag Resources with aa-criticality tag"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.modify_resource_aa_criticality_tag_value_vital
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag Resources with aa-criticality tag/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_resource_aa_criticality_tag_value_critical
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag Resources with aa-criticality tag/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_resource_aa_criticality_tag_value_important
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag Resources with aa-criticality tag/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.modify_resource_aa_criticality_tag_value_discretionary
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/tags/Modify auto tag Resources with aa-criticality tag/policyset.json")).properties.policyDefinitions[3].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_sql_server_audit_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[6].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_sql_server_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[7].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_sql_mi_audit_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Managed Instance Auditing to CSTRM Eventhub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_sql_mi_audit_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/database-services/azure-sql-database/Deploy SQL Managed Instance Auditing to CSTRM Eventhub/policyset.json")).properties.policyDefinitions[0].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_synapse_ws_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy SQL Synapse Workspace Logs to CTSRM Eventhub"
  policy_references = [
    {
      policy_definition_id = var.policy_ids.deploy_synapse_ws_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy SQL Synapse Workspace Logs to CTSRM Eventhub/policyset.json")).properties.policyDefinitions[0].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_az_defender_configuration" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters"
  policy_references = [
    {
      policy_definition_id = "/providers/microsoft.authorization/policydefinitions/9f061a12-e40d-4183-a00e-171812443373"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = "/providers/microsoft.authorization/policydefinitions/fb893a29-21bb-418c-a157-e99480ec364c"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[1].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[2].parameters)
    },
    {
      policy_definition_id = var.policy_ids.audit_aks_cluster_kub_vers
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[3].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a3dc4946-dba6-43e6-950d-f96532848c9f"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[4].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ca8d5704-aa2b-40cf-b110-dc19052825ad"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[5].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[6].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[7].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[8].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e1e6c427-07d9-46ab-9689-bfa85431e636"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[9].parameters)
    },
    {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/17f4b1cc-c55c-4d94-b1f9-2978f6ac2957"
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/azure-defender/Microsoft Defender Configuration on AKS Clusters/policyset.json")).properties.policyDefinitions[10].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

module "initiative_deploy_subscription_activity_logs_cire" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "${var.path_to_def}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Eventhubs and LAWS"
  policy_references = [
        {
      policy_definition_id = var.policy_ids.deploy_subscription_logs_to_event_hub
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Eventhubs and LAWS/policyset.json")).properties.policyDefinitions[0].parameters)
    },
    {
      policy_definition_id = var.policy_ids.deploy_subscription_cstrm_diagnostic_settings
      parameter_values     = jsonencode(jsondecode(file("${var.path_to_def}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Eventhubs and LAWS/policyset.json")).properties.policyDefinitions[1].parameters)
    }
  ]
  source = "../../definitions/initiative"
}

output "ids" {
  value = {
    enforce_aa_standard_tags                               = module.enforce_aa_standard_tags.id
    initiative_inherit_tags_from_RG2Resources              = module.initiative_inherit_tags_from_RG2Resources.id
    initiative_inherit_tags_from_RG2Resources_flex         = module.initiative_inherit_tags_from_RG2Resources_flex.id
    initiative_enforce_aa_standard_tag_values_on_resources = module.initiative_enforce_aa_standard_tag_values_on_resources.id
    intitiative_audit_sa_encryption                        = module.intitiative_audit_sa_encryption.id
    intitiative_audit_sql_server_tde                       = module.intitiative_audit_sql_server_tde.id
    initiative_audit_webapp_java_version                   = module.initiative_audit_webapp_java_version.id
    initiative_deploy_storage_account_service_logs         = module.initiative_deploy_storage_account_service_logs.id
    initiative_audit_webapp_python_version                 = module.initiative_audit_webapp_python_version.id
    initiative_audit_webapp_php_version                    = module.initiative_audit_webapp_php_version.id
    initiative_deploy_webapp_httplogs_log_to_eventhub      = module.initiative_deploy_webapp_httplogs_log_to_eventhub.id
    initiative_deploy_nsg_flow_logs                        = module.initiative_deploy_nsg_flow_logs.id
    initiative_deploy_key_vault_logs_to_eventhub           = module.initiative_deploy_key_vault_logs_to_eventhub.id
    initiative_modify_rg_aa_criticality_tag_value          = module.initiative_modify_rg_aa_criticality_tag_value.id
    initiative_deploy_function_app_logs_to_evhub_linux     = module.initiative_deploy_function_app_logs_to_evhub_linux.id
    initiative_deploy_function_app_logs_to_evhub_windows   = module.initiative_deploy_function_app_logs_to_evhub_windows.id
    initiative_modify_resource_aa_criticality_tag_value    = module.initiative_modify_resource_aa_criticality_tag_value.id
    initiative_deploy_sql_server_audit_logs_to_event_hub   = module.initiative_deploy_sql_server_audit_logs_to_event_hub.id
    initiative_deploy_sql_mi_audit_logs_to_event_hub       = module.initiative_deploy_sql_mi_audit_logs_to_event_hub.id
    initiative_deploy_synapse_ws_logs_to_event_hub         = module.initiative_deploy_synapse_ws_logs_to_event_hub.id
    initiative_az_defender_configuration                   = module.initiative_az_defender_configuration.id
    initiative_deploy_subscription_activity_logs_cire      = module.initiative_deploy_subscription_activity_logs_cire.id
  }
}
