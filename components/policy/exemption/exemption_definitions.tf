locals {
  production = "Prod"
}

module "ex_allowed_locations" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/Allowed locations/exemptions"
  source              = "../../exemptions"
}

module "ex_web_app_ftp_state" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/app-services/Enforce WebApp ftp state/exemptions"
  source              = "../../exemptions"
}

module "ex_web_app_https_only" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/app-services/Enforce WebApp httpsOnly/exemptions"
  source              = "../../exemptions"
}

module "ex_web_app_tls" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/app-services/Enforce WebApp tls/exemptions"
  source              = "../../exemptions"
}

module "ex_az_defender_policy_add_on" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/azure-defender/Deploy Policy Add-on for AKS Clusters/exemptions"
  source              = "../../exemptions"
}

module "ex_az_defender_agentless_scan" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/azure-defender/Enable AKS Agentless Scanning on Clusters and Containers/exemptions"
  source              = "../../exemptions"
}

module "ex_sql_db_deploy_transparent_data_encryption" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Deploy SQL database Transparent Database Encryption/exemptions"
  source              = "../../exemptions"
}

module "ex_sql_db_enforce_transparent_data_encryption" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce SQL Database Transparent Data Encryption/exemptions"
  source              = "../../exemptions"
}

module "ex_sql_db_allow_ingress" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/azure-sql-database/Enforce existing SQL server Auditing is set to enabled/exemptions"
  source              = "../../exemptions"
}

module "ex_cosmo_db_firewall_rules" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/cosmosdb/Enforce firewall rules on Azure Cosmos DB/exemptions"
  source              = "../../exemptions"
}

module "ex_mysql_db_ssl" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/mysql/Enforce MySQL database servers SSL connection/exemptions"
  source              = "../../exemptions"
}

module "ex_mysql_db_tls" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/mysql/Enforce MySQL database single server TLS version/exemptions"
  source              = "../../exemptions"
}

module "ex_mysql_flex_server_firewall_rules" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/mysql/Enforce no MySQL Flexible Server has Firewall rule 0.0.0.0 - 255.255.255.255/exemptions"
  source              = "../../exemptions"
}

module "ex_mysql_single_server_firewall_rules" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/mysql/Enforce no MySQL Single Server has Firewall rule 0.0.0.0 - 255.255.255.255/exemptions"
  source              = "../../exemptions"
}

module "ex_mysql_flex_server_no_public_access" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/mysql/Enforce no public access on MySQL Flexible servers/exemptions"
  source              = "../../exemptions"
}

module "ex_postgres_flex_server_firewall_rules" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Flexible server/exemptions"
  source              = "../../exemptions"
}

module "ex_postgres_single_server_firewall_rules" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/postgresql/Block adding the firewall rule 0.0.0.0-255.255.255.255 on PostgreSQL Single server/exemptions"
  source              = "../../exemptions"
}

module "ex_postgres_flex_server_no_public_access" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/postgresql/Block creation of Azure PostgreSQL Flexible Server with Public access/exemptions"
  source              = "../../exemptions"
}

module "ex_postgres_server_ssl" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/postgresql/Enforce PostgreSQL database servers SSL connection/exemptions"
  source              = "../../exemptions"
}

module "ex_postgres_single_server_disbale_allow_az_services" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/database-services/postgresql/Enforce PostgreSQL Single Server Allow all Azure Services is disabled/exemptions"
  source              = "../../exemptions"
}

module "ex_func_app_ftp_state" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/function-app/Enforce FunctionApp ftp state/exemptions"
  source              = "../../exemptions"
}

module "ex_func_app_https_only" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/app-services/Enforce FunctionApp httpsOnly/exemptions"
  source              = "../../exemptions"
}

module "ex_func_app_tls" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/app-services/Enforce FunctionApp tls/exemptions"
  source              = "../../exemptions"
}

module "ex_key_vault_key_expiration" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/key-vault/Enforce KeyVault keys expiration date/exemptions"
  source              = "../../exemptions"
}

module "ex_key_vault_secret_expiration" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/key-vault/Enforce KeyVault secrets expiration date/exemptions"
  source              = "../../exemptions"
}

module "ex_sa_minimum_tls_version" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/storage-accounts/Enforce storage account minimum TLS version/exemptions"
  source              = "../../exemptions"
}

module "ex_sa_no_public_access" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/storage-accounts/Enforce storage account public access/exemptions"
  source              = "../../exemptions"
}

module "ex_sa_no_public_access_allowed_ips" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/storage-accounts/Enforce Storage Account Public Access and Deploy Allowed IPs/exemptions"
  source              = "../../exemptions"
}

module "ex_sa_sec_transfer" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/storage-accounts/Enforce storage account secure transfer/exemptions"
  source              = "../../exemptions"
}

module "ex_block_f1_app_service_plan" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Block creation of FREE F1 App Service Plan/exemptions"
  source              = "../../exemptions"
}

module "ex_block_postgres_single_server" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Block creation of PostgreSQL Single server/exemptions"
  source              = "../../exemptions"
}

module "ex_block_acr" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Enforce ACR creation not allowed/exemptions"
  source              = "../../exemptions"
}

module "ex_block_open_ai" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/OpenAI creation Not Allowed/exemptions"
  source              = "../../exemptions"
}

module "ex_block_app_service_environment" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure App Service Environment/exemptions"
  source              = "../../exemptions"
}

module "ex_block_arc_kubernetes" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure Arc-enabled Kubernetes/exemptions"
  source              = "../../exemptions"
}

module "ex_block_arc_servers" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure Arc-enabled servers/exemptions"
  source              = "../../exemptions"
}

module "ex_block_container_apps" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure Container Apps/exemptions"
  source              = "../../exemptions"
}

module "ex_block_hd_insights" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure HDInsights/exemptions"
  source              = "../../exemptions"
}

module "ex_block_mysql_single_server" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure MySQL Single Server/exemptions"
  source              = "../../exemptions"
}

module "ex_block_nat_gateways" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure NAT gateways/exemptions"
  source              = "../../exemptions"
}

module "ex_block_native_isv_datadog" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure Native ISV Datadog/exemptions"
  source              = "../../exemptions"
}

module "ex_block_sentinel" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Azure Sentinel/exemptions"
  source              = "../../exemptions"
}

module "ex_block_db_watcher" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of DB watcher/exemptions"
  source              = "../../exemptions"
}

module "ex_block_fabric_service" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Fabric service/exemptions"
  source              = "../../exemptions"
}

module "ex_block_front_door" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Front Door/exemptions"
  source              = "../../exemptions"
}

module "ex_block_github_network" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of Github Network/exemptions"
  source              = "../../exemptions"
}

module "ex_block_unused_services" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/unused-services/Restrict creation of unused azure services/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_sql_server" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on SQLServer in Azure VM/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_redhat_linux" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Redhat Linux/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_windows_desktop" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Desktop/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_windows_server" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM for Windows Server/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_scalesets_redhat_linux" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Redhat Linux/exemptions"
  source              = "../../exemptions"
}

module "ex_hybrid_benefit_scalesets_windows_server" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce Azure Hybrid Benefit on VM scale sets for Windows Server/exemptions"
  source              = "../../exemptions"
}

module "ex_vm_managed_disk" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM managed disks/exemptions"
  source              = "../../exemptions"
}

module "ex_vm_rdp_acces" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM RDP Access/exemptions"
  source              = "../../exemptions"
}

module "ex_vm_ssh_acces" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/Enforce VM SSH Access/exemptions"
  source              = "../../exemptions"
}

module "ex_block_vm_creation" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/policies/virtual-machine/VM Creation Not Allowed/exemptions"
  source              = "../../exemptions"
}

module "ex_linux_web_app_logs" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/initiatives/monitoring/Deploy Function App (Linux) Logs to CSTRM Event Hub/exemptions"
  source              = "../../exemptions"
}

module "ex_inherit_tags_from_RG2Resources_flex" {
  display_name_prefix = var.display_name_prefix
  ex_fileset_filter   = var.ex_fileset_filter
  path_to_def         = "./azure/initiatives/tags/Inherit AA Standard Tags from Resource Group to Resources Flexibility/exemptions"
  source              = "../../exemptions"
}
