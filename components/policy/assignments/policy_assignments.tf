module "pa_audit_storage_account_resilience" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Resilience"
  policy_desc         = "Audit Storage Account Resilience. Use geo-redundancy or zone-redundancy to create highly available storage account"
  policy_id           = var.policy_ids.audit_storage_account_resilience
  source              = "../../assignments"
}

# applies to resource groups
module "pa_add_modify_tag" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/Add or modify rg tag"
  policy_desc         = "test of modify effect"
  policy_id           = "/subscriptions/55f702f9-17ee-4d42-8da3-3f0bc97c4158/providers/Microsoft.Authorization/policyDefinitions/ModifyReplaceTags"
  source              = "../../assignments"
}

# Currently there is an exception for the aa-ets-hub/aa-ets-networkvpn-sao-rg resource group to allow
# for resources to be created in the Brazil South location.
# If you update the assign.AA_GLOBAL-MG.json, please also update the assign.aa-ets-networkvpn-sao-rg.json file.
module "pa_allow_locations" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/Allowed locations"
  policy_desc         = ""
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  source              = "../../assignments"
}

module "pa_audit_cost_center" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/tags/Audit Cost Center Validation"
  policy_desc         = ""
  policy_id           = var.policy_ids.audit_cost_center_validation
  source              = "../../assignments"
}

module "pa_sql_private_endpoints" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/Configure SQL for private endpoints"
  policy_desc         = "test of deployifnotexist effect"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/8e8ca470-d980-4831-99e6-dc70d9f6af87"
  source              = "../../assignments"
}

module "pa_enforce_fa_logforwarding" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Enforce Function App Log Forwarding"
  policy_desc         = "Deploys the diagnostic settings for function app to stream to a regional Log Analytics workspace when any function app which is missing this diagnostic settings is created or updated."
  policy_id           = var.policy_ids.enforce_functionapp_log_forwarding
  with_remediation    = true
  source              = "../../assignments"
}

module "pa_vm_creation_not_allowed" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/VM Creation Not Allowed"
  policy_desc         = "Restrict VM Creation in the environment"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_openai_creation_not_allowed" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/AI Service creation Not Allowed"
  policy_desc         = "Azure OpenAI service creation is not allowed"
  policy_id           = var.policy_ids.enforce_openai_creation_not_allowed
  source              = "../../assignments"
}

module "pa_restrict_azure_arc_enabled_servers" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure Arc-enabled servers"
  policy_desc         = "Restrict creation of Azure Arc-enabled servers"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_restrict_azure_arc_enabled_kubernetes" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure Arc-enabled Kubernetes"
  policy_desc         = "Restrict creation of Azure Arc-enabled Kubernetes"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_restrict_creation_azure_container_apps" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure Container Apps"
  policy_desc         = "Restrict creation of Azure Container Apps"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_restrict_azure_github_network" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Github Network"
  policy_desc         = "Restrict creation of Github Network"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_restrict_azure_native_isv_datadog" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure Native ISV Datadog"
  policy_desc         = "Restrict creation of Azure Native ISV Datadog"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_enforce_webapp_httpsonly" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/app-services/Enforce WebApp httpsOnly"
  policy_desc         = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  policy_id           = var.policy_ids.enforce_webapp_httpsonly
  source              = "../../assignments"
}

module "pa_enforce_webapp_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/app-services/Enforce WebApp tls"
  policy_desc         = "Setting minimal TLS version to 1.2 improves security by ensuring your WebApp can only be accessed from clients using TLS 1.2. Using versions of TLS less than 1.2 is not recommended since they have well documented security vulnerabilities."
  policy_id           = var.policy_ids.enforce_webapp_tls
  source              = "../../assignments"
}

module "pa_enforce_webapp_update_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/app-services/Enforce WebApp update tls"
  policy_desc         = "Setting minimal TLS version to 1.2 improves security by ensuring your WebApp can only be accessed from clients using TLS 1.2. Using versions of TLS less than 1.2 is not recommended since they have well documented security vulnerabilities."
  policy_id           = var.policy_ids.enforce_webapp_update_tls
  source              = "../../assignments"
}

module "pa_enforce_webapp_ftp_state" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/app-services/Enforce WebApp ftp state"
  policy_desc         = "Enable ftps_only or ftp disabled for Web App's enhanced security."
  policy_id           = var.policy_ids.enforce_webapp_ftp_state
  source              = "../../assignments"
}

module "pa_enforce_webapp_update_ftp_state" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/app-services/Enforce WebApp update ftp state"
  policy_desc         = "Enable ftps_only or ftp disabled for Web App's enhanced security."
  policy_id           = var.policy_ids.enforce_webapp_update_ftp_state
  source              = "../../assignments"
}

module "pa_enforce_sql_ingress" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce no SQL Databases allow ingress 0.0.0.0_0"
  policy_desc         = "Setting firewall rules with valid IPs will reduce the potential attack surface for a SQL server, firewall rules should be defined with more granular IP addresses by referencing the range of addresses available from specific data centers. Enforce no SQL ingress with StartIp of 0.0.0.0 and EndIP of 255.255.255.255 i.e. Denying access from ANY IP over the Internet."
  policy_id           = var.policy_ids.enforce_sql_ingress
  source              = "../../assignments"
}

module "pa_enforce_vm_rdp_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce VM RDP Access"
  policy_desc         = "Azure policy to restrict RDP access to Azure Virtual Machines from the Internet."
  policy_id           = var.policy_ids.enforce_vm_rdp_access
  source              = "../../assignments"
}

module "pa_enforce_vm_ssh_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce VM SSH Access"
  policy_desc         = "Azure policy to restrict SSH access to Azure Virtual Machines from the Internet."
  policy_id           = var.policy_ids.enforce_vm_ssh_access
  source              = "../../assignments"
}

module "pa_enforce_functionapp_httpsonly" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/function-app/Enforce FunctionApp httpsOnly"
  policy_desc         = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  policy_id           = var.policy_ids.enforce_functionapp_httpsonly
  source              = "../../assignments"
}

module "pa_enforce_functionapp_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/function-app/Enforce FunctionApp tls"
  policy_desc         = "Setting minimal TLS version to 1.2 improves security by ensuring your WebApp can only be accessed from clients using TLS 1.2. Using versions of TLS less than 1.2 is not recommended since they have well documented security vulnerabilities."
  policy_id           = var.policy_ids.enforce_functionapp_tls
  source              = "../../assignments"
}

module "pa_enforce_functionapp_update_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/function-app/Enforce FunctionApp update tls"
  policy_desc         = "Setting minimal TLS version to 1.2 improves security by ensuring your WebApp can only be accessed from clients using TLS 1.2. Using versions of TLS less than 1.2 is not recommended since they have well documented security vulnerabilities."
  policy_id           = var.policy_ids.enforce_functionapp_update_tls
  source              = "../../assignments"
}

module "pa_enforce_functionapp_ftp_state" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/function-app/Enforce FunctionApp ftp state"
  policy_desc         = "Enable ftps_only or ftp disabled for Web App's enhanced security."
  policy_id           = var.policy_ids.enforce_functionapp_ftp_state
  source              = "../../assignments"
}

module "pa_enforce_functionapp_update_ftp_state" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/function-app/Enforce FunctionApp update ftp state"
  policy_desc         = "Enable ftps_only or ftp disabled for Web App's enhanced security."
  policy_id           = var.policy_ids.enforce_functionapp_update_ftp_state
  source              = "../../assignments"

}

module "pa_storage_account_secure_transfer" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Enforce storage account secure transfer"
  policy_desc         = "This policy ensures secure transfer for storage account to accept requests only from secure connections (HTTPS)."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  source              = "../../assignments"
}

module "pa_storage_account_public_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Enforce storage account public access"
  policy_desc         = "This policy prevents public access to a storage account."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
  source              = "../../assignments"
}

module "pa_keyvault_keys_expiration" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/key-vault/Enforce KeyVault keys expiration date"
  policy_desc         = "Key Vault keys should have an expiration date"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0"
  source              = "../../assignments"
}

module "pa_keyvault_secrets_expiration" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/key-vault/Enforce KeyVault secrets expiration date"
  policy_desc         = "Key Vault secrets should have an expiration date"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/98728c90-32c7-4049-8429-847dc0f4fe37"
  source              = "../../assignments"
}

module "pa_enforce_vm_managed_disks" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce VM managed disks"
  policy_desc         = "This policy restricts VMs that do not use managed disks"
  policy_id           = var.policy_ids.enforce_vm_managed_disks
  source              = "../../assignments"
}

module "pa_deploy_keyvault_logging" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy keyvault logging"
  policy_desc         = "Deploy Diagnostic Settings for Key Vault to Log Analytics workspace"
  policy_id           = var.policy_ids.deploy_keyvault_logging
  source              = "../../assignments"
}

module "pa_enforce_postgresql_db_server_ssl" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Enforce PostgreSQL database servers SSL connection"
  policy_desc         = "This configuration enforces that SSL is always enabled for accessing your database server"
  policy_id           = var.policy_ids.enforce_postgresql_db_server_ssl
  source              = "../../assignments"
}

module "pa_enforce_mysql_db_server_ssl" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Enforce MySQL database servers SSL connection"
  policy_desc         = "This configuration enforces that SSL is always enabled for accessing your database server"
  policy_id           = var.policy_ids.enforce_mysql_db_server_ssl
  source              = "../../assignments"
}

module "pa_enforce_mysql_db_server_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Enforce MySQL database single server TLS version"
  policy_desc         = "Ensure 'TLS Version' is set to >= 1.2 for MySQL Database single Servers"
  policy_id           = var.policy_ids.enforce_mysql_db_server_tls
  source              = "../../assignments"
}

module "pa_deploy_sqlserver_auditing" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy SQL Server Auditng to Log Analytics Workspace"
  policy_desc         = "Deploy SQL Server Auditing to Log Analytics workspace"
  policy_id           = var.policy_ids.deploy_sqlserver_auditing
  source              = "../../assignments"
}

module "pa_deploy_postgresql_flexible_parameter_log_checkpoints" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database flexible server parameter log_checkpoints"
  policy_desc         = "Deploy PostgreSQL database flexible server parameter log_checkpoints ON"
  policy_id           = var.policy_ids.deploy_postgresql_flexible_parameter_log_checkpoints
  source              = "../../assignments"
}

module "pa_deploy_postgresql_flexible_parameter_connection_throttling" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database flexible server parameter connection_throttling"
  policy_desc         = "Deploy PostgreSQL database flexible server parameter connection_throttling ON"
  policy_id           = var.policy_ids.deploy_postgresql_flexible_parameter_connection_throttling
  source              = "../../assignments"
}

module "pa_deploy_postgresql_single_parameter_log_checkpoints" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database single server parameter log_checkpoints"
  policy_desc         = "Deploy PostgreSQL database single server parameter log_checkpoints ON"
  policy_id           = var.policy_ids.deploy_postgresql_single_parameter_log_checkpoints
  source              = "../../assignments"
}

module "pa_deploy_postgresql_single_parameter_connection_throttling" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database single server parameter connection_throttling"
  policy_desc         = "Deploy PostgreSQL database single server parameter connection_throttling ON"
  policy_id           = var.policy_ids.deploy_postgresql_single_parameter_connection_throttling
  source              = "../../assignments"
}

module "pa_deploy_postgresql_single_parameter_log_connections" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database single server parameter log_connections"
  policy_desc         = "Deploy PostgreSQL database single server parameter log_connections ON"
  policy_id           = var.policy_ids.deploy_postgresql_single_parameter_log_connections
  source              = "../../assignments"
}

module "pa_deploy_postgresql_single_parameter_log_disconnections" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database single server parameter log_disconnections"
  policy_desc         = "Deploy PostgreSQL database single server parameter log_disconnections ON"
  policy_id           = var.policy_ids.deploy_postgresql_single_parameter_log_disconnections
  source              = "../../assignments"
}

module "pa_deploy_postgresql_single_parameter_log_retention_days" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Deploy PostgreSQL database single server parameter log_retention_days"
  policy_desc         = "Deploy PostgreSQL database single server parameter log_retention_days greater than 3"
  policy_id           = var.policy_ids.deploy_postgresql_single_parameter_log_retention_days
  source              = "../../assignments"
}

module "pa_enforce_sqlserver_auditing" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce existing SQL server Auditing is set to enabled"
  policy_desc         = "This configuration enforces that SQL Server auditing may not be disabled"
  policy_id           = var.policy_ids.enforce_sqlserver_auditing
  source              = "../../assignments"
}

module "pa_enforce_sql_db_tde" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce SQL Database Transparent Data Encryption"
  policy_desc         = "Transparent data encryption should be enabled to protect data-at-rest and meet compliance requirements. Please ignore compliance findings which includes master DB, this policy is in place to DENY existing DB TDE disable."
  policy_id           = var.policy_ids.enforce_sql_db_tde
  source              = "../../assignments"
}

module "pa_deploy_sql_db_encryption" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Deploy SQL database Transparent Database Encryption"
  policy_desc         = "Transparent data encryption should be enabled to protect data-at-rest and meet compliance requirements"
  policy_id           = var.policy_ids.deploy_sql_db_encryption
  source              = "../../assignments"
}

module "pa_aks_creation_not_allowed" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/AKS Creation Not Allowed"
  policy_desc         = "Restrict AKS Creation in the environment"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_enforce_storage_account_tls" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Enforce storage account minimum TLS version"
  policy_desc         = "Configure a minimum TLS version for secure communication between the client application and the storage account. To minimize security risk, the recommended minimum TLS version is the latest released version, which is currently TLS 1.2."
  policy_id           = var.policy_ids.enforce_storage_account_tls
  source              = "../../assignments"
}

module "pa_enforce_vm_hybrid_benefit_windows_desktop" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Desktop"
  policy_desc         = "Azure Hybrid Benefit is a licensing benefit that helps the company to significantly reduce the costs of running your virtual machine workloads in the cloud"
  policy_id           = var.policy_ids.enforce_vm_hybrid_benefit_windows_desktop
  source              = "../../assignments"
}

module "pa_enforce_vm_hybrid_benefit_windows_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Server"
  policy_desc         = "Azure Hybrid Benefit is a licensing benefit that helps the company to significantly reduce the costs of running your virtual machine workloads in the cloud"
  policy_id           = var.policy_ids.enforce_vm_hybrid_benefit_windows_server
  source              = "../../assignments"
}


module "pa_enforce_vm_scalesets_hybrid_benefit_windows_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Windows Server"
  policy_desc         = "Azure Hybrid Benefit is a licensing benefit that helps the company to significantly reduce the costs of running your virtual machine scale sets workloads in the cloud"
  policy_id           = var.policy_ids.enforce_vm_scalesets_hybrid_benefit_windows_server
  source              = "../../assignments"
}

module "pa_audit_azure_active_directory_admin_configured_on_sql" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Audit Azure Active Directory Admin configured on SQL"
  policy_desc         = "This policy audits Azure SQL Servers that do not have Azure Active Directory Admin configured"
  policy_id           = var.policy_ids.audit_azure_active_directory_admin_configured_on_sql
  source              = "../../assignments"
}

module "pa_deploy_mysql_database_flexible_server_parameter_audit_log_enabled" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Deploy MySQL database flexible server parameter audit_log_enabled"
  policy_desc         = "Ensure audit_log_enabled parameter set to ON on Azure database for MySQL flexible Servers"
  policy_id           = var.policy_ids.deploy_mysql_database_flexible_server_parameter_audit_log_enabled
  source              = "../../assignments"
}

module "pa_deploy_mysql_database_flexible_server_parameter_audit_log_events" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Deploy MySQL database flexible server parameter audit_log_events"
  policy_desc         = "Ensure audit_log_events parameter is set to include CONNECTION on Azure database for MySQL flexible Servers"
  policy_id           = var.policy_ids.deploy_mysql_database_flexible_server_parameter_audit_log_events
  source              = "../../assignments"
}

module "pa_deploy_mysql_database_single_server_parameter_audit_log_enabled" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Deploy MySQL database single server parameter audit_log_enabled"
  policy_desc         = "Ensure audit_log_enabled parameter is set to ON on Azure database for MySQL single Servers"
  policy_id           = var.policy_ids.deploy_mysql_database_single_server_parameter_audit_log_enabled
  source              = "../../assignments"
}

module "pa_deploy_mysql_database_single_server_parameter_audit_log_events" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Deploy MySQL database single server parameter audit_log_events"
  policy_desc         = "Ensure audit_log_events parameter is set to include CONNECTION on Azure database for MySQL single Servers"
  policy_id           = var.policy_ids.deploy_mysql_database_single_server_parameter_audit_log_events
  source              = "../../assignments"
}

module "pa_deploy_webapp_httplogs_log_forwading" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy WebApp httplogs log forwading"
  policy_desc         = "Deploys AppServiceHTTPLogs diagnostic settings for Azure App Service (Web App) resources to (ensure all http requests are captured and centrally logged) a Log Analytics workspace when any App Service (Web Apps) which is missing this diagnostic settings is created or updated."
  policy_id           = var.policy_ids.deploy_webapp_httplogs_log_forwading
  source              = "../../assignments"
}

module "pa_enforce_acr_creation_not_allowed" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Enforce ACR creation not allowed"
  policy_desc         = "Denies the creation of any new Azure Container Registry. All preexisting ACRs are exempt"
  policy_id           = var.policy_ids.enforce_acr_creation_not_allowed
  source              = "../../assignments"
}


module "pa_enforce_hybrid_benefit_sql_db" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Database"
  policy_desc         = "Enforces the Hybrid Benefit on Azure SQL resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_sql_db
  source              = "../../assignments"
}

module "pa_enforce_hybrid_benefit_sql_ep" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Elastic Pool"
  policy_desc         = "Enforces the Hybrid Benefit on Azure SQL resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_sql_ep
  source              = "../../assignments"
}

module "pa_enforce_hybrid_benefit_sql_mi" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/azure-sql-database/Enforce Azure Hybrid Benefit on Azure SQL Managed Instance"
  policy_desc         = "Enforces the Hybrid Benefit on Azure SQL resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_sql_mi
  source              = "../../assignments"
}

module "pa_enforce_hybrid_benefit_sql_vm" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on SQLServer in Azure VM"
  policy_desc         = "Enforces the Hybrid Benefit on Azure SQL resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_sql_vm
  source              = "../../assignments"
}

module "pa_restrict_unused_azure_services" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of unused azure services"
  policy_desc         = "Restricting Azure Services that are either in 'Not the droids' category or don 't have a Tech Radar disposition. Please open an issue in Tech Radar GitHub Repository to propose usage of this Azure Service (Resource Type) https://github.com/AAInternal/TechRadar/issues"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_deploy_subscription_cstrm_diagnostic_settings" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM"
  policy_desc         = "Deploys required diagnostic settings to forward subscription activity logs to CSTRM log analytics workspace."
  policy_id           = var.policy_ids.deploy_subscription_cstrm_diagnostic_settings
  source              = "../../assignments"
}

module "pa_restrict_unused_azure_services_audit" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/AUDIT - Restrict creation of unused azure services"
  policy_desc         = "Restricting Azure Services that are either in 'Not the droids' category or don 't have a Tech Radar disposition. Please open an issue in Tech Radar GitHub Repository to propose usage of this Azure Service (Resource Type) https://github.com/AAInternal/TechRadar/issues"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_audit_storage_account_blob_services_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit diagnostic settings for Storage Account Blob Services to Eventhub"
  policy_desc         = "Audits for read, write and delete logs for blobServices on Storage accounts"
  policy_id           = var.policy_ids.audit_storage_account_blob_services_logs
  source              = "../../assignments"
}

module "pa_audit_storage_account_queue_services_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit diagnostic settings for Storage Account Queue Services to Eventhub"
  policy_desc         = "Audits for read, write and delete logs for queue Services on Storage accounts"
  policy_id           = var.policy_ids.audit_storage_account_queue_services_logs
  source              = "../../assignments"
}

module "pa_audit_storage_account_table_services_logs" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit diagnostic settings for Storage Account Table Services to Eventhub"
  policy_desc         = "Audits for read, write and delete logs for tableServices on Storage accounts"
  policy_id           = var.policy_ids.audit_storage_account_table_services_logs
  source              = "../../assignments"
}

module "pa_audit_sa_blob_soft_delete_enabled" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Soft Delete for blobs"
  policy_desc         = "Data that is erroneously modified or deleted by an application or other storage account user will cause data loss or unavailability. Soft delete allows this data to be recovered for a specified period of time."
  policy_id           = var.policy_ids.audit_sa_blob_soft_delete_enabled
  source              = "../../assignments"
}

module "pa_audit_sa_container_soft_delete_enabled" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Soft Delete for containers"
  policy_desc         = "Data that is erroneously modified or deleted by an application or other storage account user will cause data loss or unavailability. Soft delete allows this data to be recovered for a specified period of time."
  policy_id           = var.policy_ids.audit_sa_container_soft_delete_enabled
  source              = "../../assignments"
}

module "pa_audit_sa_blob_soft_delete_retention" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Soft Delete retention days for blobs"
  policy_desc         = "Data that is erroneously modified or deleted by an application or other storage account user will cause data loss or unavailability. Soft delete allows this data to be recovered for a specified period of time."
  policy_id           = var.policy_ids.audit_sa_blob_soft_delete_retention
  source              = "../../assignments"
}

module "pa_audit_sa_container_soft_delete_retention" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Soft Delete retention days for containers"
  policy_desc         = "Data that is erroneously modified or deleted by an application or other storage account user will cause data loss or unavailability. Soft delete allows this data to be recovered for a specified period of time."
  policy_id           = var.policy_ids.audit_sa_container_soft_delete_retention
  source              = "../../assignments"
}

module "pa_audit_managed_disks_encrypted_with_pmk" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Audit managed disks encrypted with PMK"
  policy_desc         = "Ensure that Managed disks are encrypted with PMK (Platform Managed Keys). PMK encryption is enabled by default"
  policy_id           = var.policy_ids.audit_disks_encryption_with_pmk
  source              = "../../assignments"
}

module "pa_audit_sa_cross_tenant_replication" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit storage account cross-tenant replication"
  policy_desc         = "Ensure cross-tenant replication for storage accounts is disabled."
  policy_id           = var.policy_ids.audit_sa_cross_tenant_replication
  source              = "../../assignments"
}

module "pa_audit_sa_allow_azure_services" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account Allow Azure Services"
  policy_desc         = "Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access"
  policy_id           = var.policy_ids.audit_sa_allow_azure_services
  source              = "../../assignments"
}

module "pa_audit_sa_access_keys_expiry" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account access keys expiration"
  policy_desc         = "Audit storage account access keys expiry based on the key rotation period defined by AA Cybersecurity policies and standards."
  policy_id           = var.policy_ids.audit_sa_access_keys_expiry
  source              = "../../assignments"
}

module "pa_audit_sa_access_keys_rotation_reminder" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Audit Storage Account access key rotation reminder"
  policy_desc         = "Audit storage account access key rotation reminder is set as defined by AA Cybersecurity policies and standards."
  policy_id           = var.policy_ids.audit_sa_access_keys_rotation_reminder
  source              = "../../assignments"
}

module "pa_deny_cosmodb_fire_wall_enabled" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/cosmosdb/Enforce firewall rules on Azure Cosmos DB"
  policy_desc         = "Blocks the creation of Cosmos DB that only have 'Public Network access enabled' with no Vnets or Firewall rules set."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/862e97cf-49fc-4a5c-9de4-40d4e2e7c8eb"
  source              = "../../assignments"
}

module "pa_enforce_hybrid_benefit_linux_vm" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on VM for Redhat Linux"
  policy_desc         = "Enforces the Hybrid Benefit on Azure RedHat Linux VM resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_linux_vm
  source              = "../../assignments"
}

module "pa_enforce_hybrid_benefit_linux_vmss" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Redhat Linux"
  policy_desc         = "Enforces the Hybrid Benefit on Azure Redhat Linux VMSS resources"
  policy_id           = var.policy_ids.enforce_hybrid_benefit_linux_vmss
  source              = "../../assignments"
}

module "pa_restrict_creation_postgresql_flexible_server_public_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Block creation of Azure PostgreSQL Flexible Server with Public access"
  policy_desc         = "Net new creation of Azure PostgreSQL Flexible Servers will be blocked when Public Access is enabled"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/5e1de0e3-42cb-4ebc-a86d-61d0c619ca48"
  source              = "../../assignments"
}

module "pa_restrict_creation_nat_gateways" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure NAT gateways"
  policy_desc         = "Azure NAT gateway is restricted to ensure product teams are following AA security best practices"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_enforce_pgsql_single_allow_azure_services" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Enforce PostgreSQL Single Server Allow all Azure Services is disabled"
  policy_desc         = "Ensure 'Allow access to Azure services' is disabled for Azure PostgreSQL Single Server Access"
  policy_id           = var.policy_ids.enforce_pgsql_single_allow_azure_services
  source              = "../../assignments"
}

module "pa_deploy_nsg_flow_logs_90_day" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy Network Security Group Flow Logs"
  policy_desc         = "Network security will be deployed to have Flow Logs are and have a retention of at least 90 days"
  policy_id           = var.policy_ids.deploy_nsg_flow_logs_90_day
  source              = "../../assignments"
}

module "pa_block_pgsql_single_creation" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Block creation of PostgreSQL Single server"
  policy_desc         = "Net new creation of Azure PostgreSQL Single Servers will be blocked."
  policy_id           = var.policy_ids.block_pgsql_single_creation
  source              = "../../assignments"
}

module "pa_block_pgsql_single_firewall_rule" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Single server"
  policy_desc         = "Ensure that no PostgreSQL Single servers have a firewall rule with StartIP of 0.0.0.0 and EndIP of 255.255.255.255"
  policy_id           = var.policy_ids.block_pgsql_single_firewall_rule
  source              = "../../assignments"
}

module "pa_block_pgsql_flexible_firewall_rule" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Flexible server"
  policy_desc         = "Ensure that no PostgreSQL Flexible servers have a firewall rule with StartIP of 0.0.0.0 and EndIP of 255.255.255.255"
  policy_id           = var.policy_ids.block_pgsql_flexible_firewall_rule
  source              = "../../assignments"
}

module "pa_block_app_service_plan_free_sku" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Block creation of FREE F1 App Service Plan"
  policy_desc         = "Azure app service plans should use the Basic SKU or higher."
  policy_id           = var.policy_ids.block_app_service_plan_free_sku
  source              = "../../assignments"
}

module "pa_restrict_creation_app_service_env" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure App Service Environment"
  policy_desc         = "Azure App Service Environment is restricted to ensure product teams are following AA security best practices"
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_restrict_creation_front_door" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Front Door"
  policy_desc         = "Azure Front Door resources are restricted to ensure product teams are following AA security best practices"
  policy_id           = var.policy_ids.restrict_creation_front_door
  source              = "../../assignments"
}

module "pa_enforce_nsg_udp_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Enforce Network Security Group UDP Access"
  policy_desc         = "Azure Network Security Groups should be periodically evaluated for port misconfigurations."
  policy_id           = var.policy_ids.enforce_nsg_udp_access
  source              = "../../assignments"
}

module "pa_enforce_nsg_http_access" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Enforce Network Security Group HTTP Access"
  policy_desc         = "Azure Network Security Groups should be periodically evaluated for port misconfigurations."
  policy_id           = var.policy_ids.enforce_nsg_http_access
  source              = "../../assignments"
}

module "pa_restrict_creation_of_MySQL_single_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict creation of Azure MySQL Single Server"
  policy_desc         = "Azure Database for MySQL - Single Server is on the retirement path and Azure Database for MySQL - Single Server is scheduled for retirement by September 16, 2024."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  source              = "../../assignments"
}

module "pa_enforce_no_firewall_rule_on_MySQL_single_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Enforce no MySQL Single Server has Firewall rule 0.0.0.0 - 255.255.255.255"
  policy_desc         = "Blocking the firewall rule 0.0.0.0 - 255.255.255.255 will help mitigate unauthorized access from the internet."
  policy_id           = var.policy_ids.enforce_no_firewall_rule_on_MySQL_single_server
  source              = "../../assignments"
}

module "pa_enforce_no_firewall_rule_MySQL_flex_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Enforce no MySQL Flexible Server has Firewall rule 0.0.0.0 - 255.255.255.255"
  policy_desc         = "In order to reduce the potential attack surface for existing MySQL Flexible servers, firewall rules should be defined with more granular IP addresses by referencing the range of addresses available from trusted sources."
  policy_id           = var.policy_ids.enforce_no_firewall_rule_MySQL_flex_server
  source              = "../../assignments"
}

module "pa_enforce_no_public_access_MySQL_flex_server" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/mysql/Enforce no public access on MySQL Flexible servers"
  policy_desc         = "In order to reduce the potential attack surface for existing MySQL Flexible servers should have public access disabled unless firewalls are explicitly defined."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/c9299215-ae47-4f50-9c54-8a392f68a052"
  source              = "../../assignments"
}

module "pa_inherit_aa-app-id_from_rg_resources" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/tags/Inherit aa-app-id tag from resource group to resources"
  policy_desc         = "Adds the specified tag with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."
  policy_id           = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
  source              = "../../assignments"
}

module "pa_audit_aa_app_shortname" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/tags/AuditAAAppShortName"
  policy_desc         = "Audit for missing aa-app-short-name tag or invalid values"
  policy_id           = var.policy_ids.audit_aa_app_shortname
  source              = "../../assignments"
}

module "pa_audit_cosmosdb_network_configuration" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/cosmosdb/Audit Cosmos DB configured without PrivateEndpoint or VirtualNetworkServiceEndpoint"
  policy_desc         = "Cosmos DB should be configured using a private link or  virtual network service endpoint"
  policy_id           = var.policy_ids.audit_cosmosdb_network_configuration
  source              = "../../assignments"
}

module "pa_block_cosmosdb_fire_wall_rules" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/database-services/cosmosdb/Block adding firewall rules on Azure cosmos DB"
  policy_desc         = "Deny if Cosmos DB is configured using Allow access from my IP and block adding firewall rules on Azure cosmos DB ."
  policy_id           = var.policy_ids.block_cosmosdb_fire_wall_rules
  source              = "../../assignments"
}

module "pa_deploy_subscription_logs_to_event_hub" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/monitoring/Deploy Subscription Activity Log Diagnostic Settings to CSTRM Event Hub"
  policy_desc         = "Deploys required diagnostic settings to forward subscription activity logs to a CSTRM Event Hub."
  policy_id           = var.policy_ids.deploy_subscription_logs_to_event_hub
  source              = "../../assignments"
}

module "pa_enable_aks_agentless_scan" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/azure-defender/Enable AKS Agentless Scanning on Clusters and Containers"
  policy_desc         = "Enables only the agentless scanning associated with Azure Defender for AKS. This policy will be deprecated once we enable Azure Defender."
  policy_id           = var.policy_ids.enable_aks_agentless_scan
  source              = "../../assignments"
}

module "pa_enable_policy_add_on_aks" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/azure-defender/Deploy Policy Add-on for AKS Clusters"
  policy_desc         = "Enables the policy add-on on AKS clusters so we can apply AZ polcies at the cluster level"
  policy_id           = "/providers/microsoft.authorization/policydefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7"
  source              = "../../assignments"
}

module "pa_enforce_storage_account_public_access_allowed_ips" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/storage-accounts/Enforce Storage Account Public Access and Deploy Allowed IPs"
  policy_desc         = "Enables the policy add-on on AKS clusters so we can apply AZ polcies at the cluster level"
  policy_id           = var.policy_ids.enforce_storage_account_public_access_allowed_ips
  source              = "../../assignments"
}

module "pa_block_propating_gateway_routes_on_route_tables" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/network/Block propagating gateway routes on Route table"
  policy_desc         = "Blocks the propagation of routes to the network interfaces in associated subnets for the route table"
  policy_id           = var.policy_ids.block_propating_gateway_routes_on_route_tables
  source              = "../../assignments"
}

module "pa_inherit_tags_from_RG2Resources_flex" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility"
  policy_desc         = "Inherit AA Standard Tags from Resource Group to Resources Flexibility"
  policy_id           = var.policy_ids.inherit_tags_from_RG2Resources_flex
  source              = "../../assignments"
}

module "pa_restrict_az_open_ai_models" {
  display_name_prefix = var.display_name_prefix
  fileset_filter      = var.fileset_filter
  path_to_dir         = "${var.path_to_policies}/unused-services/Restrict Azure Open AI Models"
  policy_desc         = "Restricts the deployment of certain AI models within the AA environment."
  policy_id           = var.policy_ids.restrict_az_open_ai_models
  source              = "../../assignments"
}
