locals {
  production = "Prod"
}

module "audit_storage_account_resilience" {
  display_name_prefix = var.display_name_prefix
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  name_suffix         = var.name_suffix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Resilience"
  source              = "../../definitions/policy"
}

module "enforce_aa_sdlc" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/EnforceAASdlcEnvironment"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_log_forwarding" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Enforce Function App Log Forwarding"
  management_group_id = var.environment == local.production ? "production-mg" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_cost_center_validation" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/EnforceCostCenterValidation"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_cost_center_validation" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Audit Cost Center Validation"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_resource_group_parameter" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/EnforceResourceGroupParameter"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_aa_app_shortname" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/EnforceAAAppShortName"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "inherit_tags_from_RG2Resources" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Inherit AA Standard Tags from Resource Group to Resources"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "inherit_tags_from_RG2Resources_flex" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_webapp_httpsonly" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Enforce WebApp httpsOnly"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_webapp_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Enforce WebApp tls"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_webapp_update_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Enforce WebApp update tls"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_webapp_ftp_state" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Enforce WebApp ftp state"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_webapp_update_ftp_state" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Enforce WebApp update ftp state"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_sql_ingress" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce no SQL Databases allow ingress 0.0.0.0_0"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_rdp_access" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM RDP Access"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_ssh_access" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM SSH Access"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_httpsonly" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp httpsOnly"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp tls"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_update_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp update tls"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_ftp_state" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp ftp state"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_functionapp_update_ftp_state" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp update ftp state"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_keyvault_logging" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy keyvault logging"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_postgresql_db_server_ssl" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Enforce PostgreSQL database servers SSL connection"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_mysql_db_server_ssl" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Enforce MySQL database servers SSL connection"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_mysql_db_server_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Enforce MySQL database single server TLS version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_managed_disks" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM managed disks"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_flexible_parameter_log_checkpoints" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database flexible server parameter log_checkpoints"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_flexible_parameter_connection_throttling" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database flexible server parameter connection_throttling"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_single_parameter_connection_throttling" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database single server parameter connection_throttling"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_single_parameter_log_checkpoints" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database single server parameter log_checkpoints"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_single_parameter_log_connections" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database single server parameter log_connections"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_single_parameter_log_disconnections" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database single server parameter log_disconnections"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_postgresql_single_parameter_log_retention_days" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Deploy PostgreSQL database single server parameter log_retention_days"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_sqlserver_auditing" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy SQL Server Auditng to Log Analytics Workspace"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_sqlserver_auditing" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce existing SQL server Auditing is set to enabled"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_sql_db_encryption" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Deploy SQL database Transparent Database Encryption"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_sql_db_tde" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce SQL Database Transparent Data Encryption"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_storage_account_tls" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Enforce storage account minimum TLS version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_hybrid_benefit_windows_desktop" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Desktop"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_hybrid_benefit_windows_server" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Server"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_vm_scalesets_hybrid_benefit_windows_server" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Windows Server"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}


module "audit_azure_active_directory_admin_configured_on_sql" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Audit Azure Active Directory Admin configured on SQL"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}


module "deploy_mysql_database_flexible_server_parameter_audit_log_enabled" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Deploy MySQL database flexible server parameter audit_log_enabled"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_mysql_database_flexible_server_parameter_audit_log_events" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Deploy MySQL database flexible server parameter audit_log_events"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_mysql_database_single_server_parameter_audit_log_enabled" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Deploy MySQL database single server parameter audit_log_enabled"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_mysql_database_single_server_parameter_audit_log_events" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Deploy MySQL database single server parameter audit_log_events"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_webapp_httplogs_log_forwading" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy WebApp httplogs log forwading"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_openai_creation_not_allowed" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/AI Service creation Not Allowed"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_sql_db" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Database"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_sql_ep" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Elastic Pool"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_sql_mi" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Managed Instance"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_sql_vm" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on SQLServer in Azure VM"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}
module "deploy_subscription_cstrm_diagnostic_settings" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}
module "enforce_aa_app_shortname_tag_value_on_resources" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Enforce Valid aa-app-shortname Tag Values on Resources"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_aa_costcenter_tag_value" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Enforce Valid aa-costcenter Tag Values"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_aa_sdlc_environment_tag_value_on_resources" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Enforce Valid aa-sdlc-environment Tag Values on Resources"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_storage_account_service_logs" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy Storage Accounts service logs"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_storage_account_queue_services_logs" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit diagnostic settings for Storage Account Queue Services to Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_storage_account_table_services_logs" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit diagnostic settings for Storage Account Table Services to Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_storage_account_blob_services_logs" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit diagnostic settings for Storage Account Blob Services to Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_container_soft_delete_enabled" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Soft Delete for containers"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_blob_soft_delete_enabled" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Soft Delete for blobs"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_blob_soft_delete_retention" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Soft Delete retention days for blobs"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_container_soft_delete_retention" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Soft Delete retention days for containers"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_disks_encryption_with_pmk" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Audit managed disks encrypted with PMK"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_encryption" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Encryption Type"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_access_keys_expiry" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account access keys expiration"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_access_keys_rotation_reminder" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account access key rotation reminder"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sql_server_tde" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Audit SQL Server Transparent Data Encryption Type"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_java_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Java Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_slot_java_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Slot Java Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_cross_tenant_replication" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit storage account cross-tenant replication"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_sa_allow_azure_services" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Audit Storage Account Allow Azure Services"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_linux_vm" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Redhat Linux"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_hybrid_benefit_linux_vmss" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Redhat Linux"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_pgsql_single_allow_azure_services" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Enforce PostgreSQL Single Server Allow all Azure Services is disabled"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_python_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Python Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_slot_python_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Slot Python Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_nsg_flow_logs_90_day" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy Network Security Group Flow Logs"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_pgsql_single_creation" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/Block creation of PostgreSQL Single server"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_pgsql_single_firewall_rule" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Single server"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_pgsql_flexible_firewall_rule" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Flexible server"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_app_service_plan_free_sku" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/Block creation of FREE F1 App Service Plan"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "restrict_creation_front_door" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Front Door"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_nsg_udp_access" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Enforce Network Security Group UDP Access"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_nsg_http_access" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Enforce Network Security Group HTTP Access"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_no_firewall_rule_on_MySQL_single_server" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Enforce no MySQL Single Server has Firewall rule 0.0.0.0 - 255.255.255.255"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_no_firewall_rule_MySQL_flex_server" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/mysql/Enforce no MySQL Flexible Server has Firewall rule 0.0.0.0 - 255.255.255.255"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_acr_creation_not_allowed" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/Enforce ACR creation not allowed"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_aa_app_shortname" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/AuditAAAppShortName"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_php_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Php Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_webapp_slot_php_version" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/app-services/Audit WebApp Slot Php Version"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_webapp_httplogs_log_to_eventhub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy WebApp httplogs Log Forwarding to CSTRM Event Hub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_cosmosdb_network_configuration" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/cosmosdb/Audit Cosmos DB configured without PrivateEndpoint or VirtualNetworkServiceEndpoint"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_cosmosdb_fire_wall_rules" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/cosmosdb/Audit Block adding firewall rules on Azure cosmos DB"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_key_vault_logs_to_eventhub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy Keyvault Logs to CSTRM Event Hub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_rg_aa_criticality_tag_value_vital" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag ResourceGroups with aa-criticality tag - vital"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_rg_aa_criticality_tag_value_critical" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag ResourceGroups with aa-criticality tag - critical"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_rg_aa_criticality_tag_value_important" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag ResourceGroups with aa-criticality tag - important"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_rg_aa_criticality_tag_value_discretionary" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag ResourceGroups with aa-criticality tag - discretionary"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

# Needed by AOT for an Internal Policy, follow up with Jerry Springer for removal
module "matching_tags_from_RG" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Enforce Resource Matches Parent RG"
  management_group_id = var.environment == local.production ? "AA_GLOBAL-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_function_app_logs_to_eventhub_os" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Enforce Function App Log Forwarding to Eventhub by OS"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_resource_aa_criticality_tag_value_vital" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag Resources with aa-criticality tag - vital"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_resource_aa_criticality_tag_value_critical" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag Resources with aa-criticality tag - critical"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_resource_aa_criticality_tag_value_important" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag Resources with aa-criticality tag - important"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "modify_resource_aa_criticality_tag_value_discretionary" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/tags/Modify auto tag Resources with aa-criticality tag - discretionary"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_subscription_logs_to_event_hub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Event Hub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_sql_server_audit_logs_to_event_hub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Deploy SQL Server Auditing to CSTRM Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_sql_mi_audit_logs_to_event_hub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Deploy SQL Managed Instance Auditing to CSTRM Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "deploy_synapse_ws_logs_to_event_hub" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/monitoring/Deploy SQL Synapse Workspace Logs to CTSRM Eventhub"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "audit_aks_cluster_kub_vers" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/azure-defender/Audit AKS Cluster using Kubernetes version less than 1.30"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enable_aks_agentless_scan" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/azure-defender/Enable AKS Agentless Scanning on Clusters and Containers"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "block_propating_gateway_routes_on_route_tables" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/network/Block propagating gateway routes on Route table"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enforce_storage_account_public_access_allowed_ips" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/storage-accounts/Enforce Storage Account Public Access and Deploy Allowed IPs"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "enable_policy_add_on_aks" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/azure-defender/Deploy Policy Add-on for AKS Clusters"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

module "restrict_az_open_ai_models" {
  name_suffix         = var.name_suffix
  display_name_prefix = var.display_name_prefix
  path_to_def         = "./azure/policies/unused-services/Restrict Azure Open AI Models"
  management_group_id = var.environment == local.production ? "PRODUCTION-MG" : var.management_group_id
  source              = "../../definitions/policy"
}

output "ids" {
  value = {
    enforce_aa_app_shortname                                          = module.enforce_aa_app_shortname.id,
    enforce_aa_sdlc                                                   = module.enforce_aa_sdlc.id,
    enforce_cost_center_validation                                    = module.enforce_cost_center_validation.id,
    audit_cost_center_validation                                      = module.audit_cost_center_validation.id,
    enforce_functionapp_log_forwarding                                = module.enforce_functionapp_log_forwarding.id,
    enforce_resource_group_parameter                                  = module.enforce_resource_group_parameter.id,
    inherit_tags_from_RG2Resources                                    = module.inherit_tags_from_RG2Resources.id
    inherit_tags_from_RG2Resources_flex                               = module.inherit_tags_from_RG2Resources_flex.id
    enforce_webapp_httpsonly                                          = module.enforce_webapp_httpsonly.id
    enforce_webapp_tls                                                = module.enforce_webapp_tls.id
    enforce_webapp_update_tls                                         = module.enforce_webapp_update_tls.id
    enforce_webapp_ftp_state                                          = module.enforce_webapp_ftp_state.id
    enforce_webapp_update_ftp_state                                   = module.enforce_webapp_update_ftp_state.id
    enforce_sql_ingress                                               = module.enforce_sql_ingress.id
    enforce_vm_rdp_access                                             = module.enforce_vm_rdp_access.id
    enforce_vm_ssh_access                                             = module.enforce_vm_ssh_access.id
    enforce_functionapp_httpsonly                                     = module.enforce_functionapp_httpsonly.id
    enforce_functionapp_tls                                           = module.enforce_functionapp_tls.id
    enforce_functionapp_update_tls                                    = module.enforce_functionapp_update_tls.id
    enforce_functionapp_ftp_state                                     = module.enforce_functionapp_ftp_state.id
    enforce_functionapp_update_ftp_state                              = module.enforce_functionapp_update_ftp_state.id
    deploy_keyvault_logging                                           = module.deploy_keyvault_logging.id
    enforce_postgresql_db_server_ssl                                  = module.enforce_postgresql_db_server_ssl.id
    enforce_mysql_db_server_ssl                                       = module.enforce_mysql_db_server_ssl.id
    enforce_mysql_db_server_tls                                       = module.enforce_mysql_db_server_tls.id
    enforce_vm_managed_disks                                          = module.enforce_vm_managed_disks.id
    deploy_postgresql_flexible_parameter_log_checkpoints              = module.deploy_postgresql_flexible_parameter_log_checkpoints.id
    deploy_postgresql_flexible_parameter_connection_throttling        = module.deploy_postgresql_flexible_parameter_connection_throttling.id
    deploy_postgresql_single_parameter_connection_throttling          = module.deploy_postgresql_single_parameter_connection_throttling.id
    deploy_postgresql_single_parameter_log_checkpoints                = module.deploy_postgresql_single_parameter_log_checkpoints.id
    deploy_postgresql_single_parameter_log_connections                = module.deploy_postgresql_single_parameter_log_connections.id
    deploy_postgresql_single_parameter_log_disconnections             = module.deploy_postgresql_single_parameter_log_disconnections.id
    deploy_postgresql_single_parameter_log_retention_days             = module.deploy_postgresql_single_parameter_log_retention_days.id
    deploy_sqlserver_auditing                                         = module.deploy_sqlserver_auditing.id
    enforce_sqlserver_auditing                                        = module.enforce_sqlserver_auditing.id
    deploy_sql_db_encryption                                          = module.deploy_sql_db_encryption.id
    enforce_sql_db_tde                                                = module.enforce_sql_db_tde.id
    enforce_storage_account_tls                                       = module.enforce_storage_account_tls.id
    enforce_vm_hybrid_benefit_windows_desktop                         = module.enforce_vm_hybrid_benefit_windows_desktop.id
    enforce_vm_hybrid_benefit_windows_server                          = module.enforce_vm_hybrid_benefit_windows_server.id
    enforce_vm_scalesets_hybrid_benefit_windows_server                = module.enforce_vm_scalesets_hybrid_benefit_windows_server.id
    audit_azure_active_directory_admin_configured_on_sql              = module.audit_azure_active_directory_admin_configured_on_sql.id
    deploy_mysql_database_flexible_server_parameter_audit_log_enabled = module.deploy_mysql_database_flexible_server_parameter_audit_log_enabled.id
    deploy_mysql_database_flexible_server_parameter_audit_log_events  = module.deploy_mysql_database_flexible_server_parameter_audit_log_events.id
    deploy_mysql_database_single_server_parameter_audit_log_enabled   = module.deploy_mysql_database_single_server_parameter_audit_log_enabled.id
    deploy_mysql_database_single_server_parameter_audit_log_events    = module.deploy_mysql_database_single_server_parameter_audit_log_events.id
    deploy_webapp_httplogs_log_forwading                              = module.deploy_webapp_httplogs_log_forwading.id
    enforce_openai_creation_not_allowed                               = module.enforce_openai_creation_not_allowed.id
    enforce_hybrid_benefit_sql_db                                     = module.enforce_hybrid_benefit_sql_db.id
    enforce_hybrid_benefit_sql_ep                                     = module.enforce_hybrid_benefit_sql_ep.id
    enforce_hybrid_benefit_sql_mi                                     = module.enforce_hybrid_benefit_sql_mi.id
    enforce_hybrid_benefit_sql_vm                                     = module.enforce_hybrid_benefit_sql_vm.id
    deploy_subscription_cstrm_diagnostic_settings                     = module.deploy_subscription_cstrm_diagnostic_settings.id
    enforce_aa_app_shortname_tag_value_on_resources                   = module.enforce_aa_app_shortname_tag_value_on_resources.id
    enforce_aa_costcenter_tag_value                                   = module.enforce_aa_costcenter_tag_value.id
    enforce_aa_sdlc_environment_tag_value_on_resources                = module.enforce_aa_sdlc_environment_tag_value_on_resources.id
    deploy_storage_account_service_logs                               = module.deploy_storage_account_service_logs.id
    audit_storage_account_blob_services_logs                          = module.audit_storage_account_blob_services_logs.id
    audit_storage_account_queue_services_logs                         = module.audit_storage_account_queue_services_logs.id
    audit_storage_account_table_services_logs                         = module.audit_storage_account_table_services_logs.id
    audit_sa_blob_soft_delete_enabled                                 = module.audit_sa_blob_soft_delete_enabled.id
    audit_sa_container_soft_delete_enabled                            = module.audit_sa_container_soft_delete_enabled.id
    audit_sa_blob_soft_delete_retention                               = module.audit_sa_blob_soft_delete_retention.id
    audit_sa_container_soft_delete_retention                          = module.audit_sa_container_soft_delete_retention.id
    audit_disks_encryption_with_pmk                                   = module.audit_disks_encryption_with_pmk.id
    audit_sa_encryption                                               = module.audit_sa_encryption.id
    audit_sa_access_keys_expiry                                       = module.audit_sa_access_keys_expiry.id
    audit_sa_access_keys_rotation_reminder                            = module.audit_sa_access_keys_rotation_reminder.id
    audit_sql_server_tde                                              = module.audit_sql_server_tde.id
    audit_webapp_java_version                                         = module.audit_webapp_java_version.id
    audit_webapp_slot_java_version                                    = module.audit_webapp_slot_java_version.id
    audit_sa_cross_tenant_replication                                 = module.audit_sa_cross_tenant_replication.id
    audit_sa_allow_azure_services                                     = module.audit_sa_allow_azure_services.id
    enforce_hybrid_benefit_linux_vm                                   = module.enforce_hybrid_benefit_linux_vm.id
    enforce_hybrid_benefit_linux_vmss                                 = module.enforce_hybrid_benefit_linux_vmss.id
    enforce_pgsql_single_allow_azure_services                         = module.enforce_pgsql_single_allow_azure_services.id
    audit_webapp_python_version                                       = module.audit_webapp_python_version.id
    audit_webapp_slot_python_version                                  = module.audit_webapp_slot_python_version.id
    deploy_nsg_flow_logs_90_day                                       = module.deploy_nsg_flow_logs_90_day.id
    block_pgsql_single_creation                                       = module.block_pgsql_single_creation.id
    block_pgsql_single_firewall_rule                                  = module.block_pgsql_single_firewall_rule.id
    block_pgsql_flexible_firewall_rule                                = module.block_pgsql_flexible_firewall_rule.id
    block_app_service_plan_free_sku                                   = module.block_app_service_plan_free_sku.id
    restrict_creation_front_door                                      = module.restrict_creation_front_door.id
    enforce_nsg_udp_access                                            = module.enforce_nsg_udp_access.id
    enforce_nsg_http_access                                           = module.enforce_nsg_http_access.id
    enforce_no_firewall_rule_on_MySQL_single_server                   = module.enforce_no_firewall_rule_on_MySQL_single_server.id
    enforce_no_firewall_rule_MySQL_flex_server                        = module.enforce_no_firewall_rule_MySQL_flex_server.id
    enforce_acr_creation_not_allowed                                  = module.enforce_acr_creation_not_allowed.id
    audit_aa_app_shortname                                            = module.audit_aa_app_shortname.id
    audit_webapp_php_version                                          = module.audit_webapp_php_version.id
    audit_webapp_slot_php_version                                     = module.audit_webapp_slot_php_version.id
    deploy_webapp_httplogs_log_to_eventhub                            = module.deploy_webapp_httplogs_log_to_eventhub.id
    audit_cosmosdb_network_configuration                              = module.audit_cosmosdb_network_configuration.id
    block_cosmosdb_fire_wall_rules                                    = module.block_cosmosdb_fire_wall_rules.id
    deploy_key_vault_logs_to_eventhub                                 = module.deploy_key_vault_logs_to_eventhub.id
    modify_rg_aa_criticality_tag_value_vital                          = module.modify_rg_aa_criticality_tag_value_vital.id
    modify_rg_aa_criticality_tag_value_critical                       = module.modify_rg_aa_criticality_tag_value_critical.id
    modify_rg_aa_criticality_tag_value_important                      = module.modify_rg_aa_criticality_tag_value_important.id
    modify_rg_aa_criticality_tag_value_discretionary                  = module.modify_rg_aa_criticality_tag_value_discretionary.id
    matching_tags_from_RG                                             = module.matching_tags_from_RG.id
    deploy_function_app_logs_to_eventhub_os                           = module.deploy_function_app_logs_to_eventhub_os.id
    modify_resource_aa_criticality_tag_value_vital                    = module.modify_resource_aa_criticality_tag_value_vital.id
    modify_resource_aa_criticality_tag_value_critical                 = module.modify_resource_aa_criticality_tag_value_critical.id
    modify_resource_aa_criticality_tag_value_important                = module.modify_resource_aa_criticality_tag_value_important.id
    modify_resource_aa_criticality_tag_value_discretionary            = module.modify_resource_aa_criticality_tag_value_discretionary.id
    deploy_subscription_logs_to_event_hub                             = module.deploy_subscription_logs_to_event_hub.id
    deploy_sql_server_audit_logs_to_event_hub                         = module.deploy_sql_server_audit_logs_to_event_hub.id
    deploy_sql_mi_audit_logs_to_event_hub                             = module.deploy_sql_mi_audit_logs_to_event_hub.id
    audit_storage_account_resilience                                  = module.audit_storage_account_resilience.id
    deploy_synapse_ws_logs_to_event_hub                               = module.deploy_synapse_ws_logs_to_event_hub.id
    audit_aks_cluster_kub_vers                                        = module.audit_aks_cluster_kub_vers.id
    enable_aks_agentless_scan                                         = module.enable_aks_agentless_scan.id
    block_propating_gateway_routes_on_route_tables                    = module.block_propating_gateway_routes_on_route_tables.id
    enforce_storage_account_public_access_allowed_ips                 = module.enforce_storage_account_public_access_allowed_ips.id
    enable_policy_add_on_aks                                          = module.enable_policy_add_on_aks.id
    restrict_az_open_ai_models                                        = module.restrict_az_open_ai_models.id
  }
}
