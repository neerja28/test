module "pa_no_PIP_unless_network_RG" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/networking/Enforce no PIPs unless in a Network RG"
  policy_desc         = "Only Network and Network Security teams may create Public IPs (PIPs). Set exclusion during assignment to allow their RGs."
  policy_id           = "/providers/Microsoft.Management/managementGroups/AA_GLOBAL-MG/providers/Microsoft.Authorization/policySetDefinitions/5bd4ea3e-676f-460d-beec-c6f418a1d47c"
  source              = "../../assignments"
}

module "pa_enforce_aa_standard_tags_on_rgs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Enforce AA Standard Tags on Resource Groups"
  policy_desc         = "Enforce valid aa-app-shortname is set, aa-sdlc-environment is dev, test, stage, nonprod, or prod with optional 1-4 digits afterwards."
  policy_id           = var.policy_ids.enforce_aa_standard_tags
  source              = "../../assignments"
}

module "pa_inherit_aa_standard_tags_from_RG2Resources" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Inherit AA Standard Tags from Resource Group to Resources"
  policy_desc         = "Each AA Standard Tag is copied down from parent Resource Group to the Resources within it, unless that Resource already has that Tag and value set."
  policy_id           = var.policy_ids.initiative_inherit_tags_from_RG2Resources
  source              = "../../assignments"
}

module "pa_inherit_aa_standard_tags_from_RG2Resources_flex" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility"
  policy_desc         = "Each AA Standard Tag is copied down from parent Resource Group to the Resources within it, unless that Resource already has that Tag and value set."
  policy_id           = var.policy_ids.initiative_inherit_tags_from_RG2Resources_flex
  source              = "../../assignments"
}

module "pa_enforce_aa_standard_tag_values_on_resources" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Enforce Valid AA Standard Tag Values on Resources"
  policy_desc         = "When creating a new Resource, the AA Standard Tags must have valid values. If not, they will be inherited from the parent resource group."
  policy_id           = var.policy_ids.initiative_enforce_aa_standard_tag_values_on_resources
  source              = "../../assignments"
}

module "pa_audit_sa_encryption" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/storage-accounts/Audit Storage Account Encryption Type"
  policy_desc         = "Audit the encryption type of Storage Accounts for Platform Managed Keys and Cutsomer Managed keys."
  policy_id           = var.policy_ids.intitiative_audit_sa_encryption
  source              = "../../assignments"
}

module "pa_intitiative_audit_sql_server_tde" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/database-services/azure-sql-database/Audit SQL Server Transparent Data Encryption Type"
  policy_desc         = "SQL Servers must be encrypted with Platform Managed Key or Customer Managed Key."
  policy_id           = var.policy_ids.intitiative_audit_sql_server_tde
  source              = "../../assignments"
}

module "pa_initiative_audit_webapp_java_version" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/app-services/Audit WebApp Java Version"
  policy_desc         = "Audit the Java version of Web Apps and Web App Slots."
  policy_id           = var.policy_ids.initiative_audit_webapp_java_version
  source              = "../../assignments"
}

module "pa_deploy_storage_account_service_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Storage Accounts Service Logs Initiative"
  policy_desc         = "Enables read, write and delete logs forwarding to CSTRM Event Hub for queueServices, blobServices, and tableServices on Storage accounts"
  policy_id           = var.policy_ids.initiative_deploy_storage_account_service_logs
  source              = "../../assignments"
}

module "pa_initiative_audit_webapp_python_version" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/app-services/Audit WebApp Python Version"
  policy_desc         = "Audit the Python version of Web Apps and Web App Slots."
  policy_id           = var.policy_ids.initiative_audit_webapp_python_version
  source              = "../../assignments"
}

module "pa_initiative_audit_webapp_php_version" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/app-services/Audit WebApp Php Version"
  policy_desc         = "Audit the Php version of Web Apps and Web App Slots."
  policy_id           = var.policy_ids.initiative_audit_webapp_php_version
  source              = "../../assignments"
}

module "pa_deploy_web_app_http_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub"
  policy_desc         = "Enables http logs forwarding to CSTRM Event Hub for Web Apps/App Services"
  policy_id           = var.policy_ids.initiative_deploy_webapp_httplogs_log_to_eventhub
  source              = "../../assignments"
}

module "pa_deploy_nsg_flow_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Network Security Group Flow Logs"
  policy_desc         = "Enables flow log forwarding to storage accounts with 90 day retention"
  policy_id           = var.policy_ids.initiative_deploy_nsg_flow_logs
  source              = "../../assignments"
}

module "pa_deploy_key_vault_logs_to_eventhub" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Keyvault Logs to CSTRM Event Hub"
  policy_desc         = "Deploys Key Vault logs to approved CSTRM eventhub for retention"
  policy_id           = var.policy_ids.initiative_deploy_key_vault_logs_to_eventhub
  source              = "../../assignments"
}

module "pa_modify_rg_aa_criticality_tag_value" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Modify auto tag ResourceGroups with aa-criticality tag"
  policy_desc         = "Adds aa-criticality tag and its corresponding value as per Archer record to Resource group."
  policy_id           = var.policy_ids.initiative_modify_rg_aa_criticality_tag_value
  source              = "../../assignments"
}


module "pa_deploy_function_app_logs_to_evhub_linux" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub"
  policy_desc         = "Deploys the Diagnostic Settings' Logs from Function Apps a regional Event Hub when the function app is created, updated or modified."
  policy_id           = var.policy_ids.initiative_deploy_function_app_logs_to_evhub_linux
  source              = "../../assignments"
}

module "pa_deploy_function_app_logs_to_evhub_windows" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Function App (Windows) Logs to CSTRM Event Hub"
  policy_desc         = "Deploys the Diagnostic Settings' Logs from Function Apps a regional Event Hub when the function app is created, updated or modified."
  policy_id           = var.policy_ids.initiative_deploy_function_app_logs_to_evhub_windows
  source              = "../../assignments"
}

module "pa_modify_resource_aa_criticality_tag_value" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/tags/Modify auto tag Resources with aa-criticality tag"
  policy_desc         = "Adds aa-criticality tag and its corresponding value as per Archer record to Resource."
  policy_id           = var.policy_ids.initiative_modify_resource_aa_criticality_tag_value
  source              = "../../assignments"
}

module "pa_deploy_sql_server_audit_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub"
  policy_desc         = "Enables SQL server audit logs and deploys them to the corresponding CSTRM event hub"
  policy_id           = var.policy_ids.initiative_deploy_sql_server_audit_logs_to_event_hub
  source              = "../../assignments"
}

module "pa_enforce_az_data_center_protection" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/database-services/azure-sql-database/Enforce Azure Data Center Data Protection"
  policy_desc         = "This is a builtin policy that enable Azure Defender on all SQL instances"
  policy_id           = "/providers/microsoft.authorization/policysetdefinitions/9cb3cc7a-b39b-4b82-bc89-e5a5d9ff7b97"
  source              = "../../assignments"
}

module "pa_deploy_sql_mi_audit_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/database-services/azure-sql-database/Deploy SQL Managed Instance Auditing to CSTRM Eventhub"
  policy_desc         = "Deploys SQL Managed Instance diagnostic settings logs to the designated CSTRM Event Hub"
  policy_id           = var.policy_ids.initiative_deploy_sql_mi_audit_logs_to_event_hub
  source              = "../../assignments"
}

module "pa_deploy_synapse_ws_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy SQL Synapse Workspace Logs to CTSRM Eventhub"
  policy_desc         = "Deploys Azure Synapse Workspace diagnostic settings logs to the designated CSTRM Event Hub"
  policy_id           = var.policy_ids.initiative_deploy_synapse_ws_logs_to_event_hub
  source              = "../../assignments"
}

module "pa_initiative_az_defender_configuration" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/azure-defender/Microsoft Defender Configuration on AKS Clusters"
  policy_desc         = "Deploys the Azure Microsoft Defender for testing "
  policy_id           = var.policy_ids.initiative_az_defender_configuration
  source              = "../../assignments"
}

module "pa_initiative_deploy_subscription_activity_logs_cire" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_initiatives}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Eventhubs and LAWS"
  policy_desc         = "Deploys the Azure Microsoft Defender for testing "
  policy_id           = var.policy_ids.initiative_deploy_subscription_activity_logs_cire
  source              = "../../assignments"
}
