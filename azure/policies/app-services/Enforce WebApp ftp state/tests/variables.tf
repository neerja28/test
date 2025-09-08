variable "webapp_name"{
  description = "Name to be given to the WebApp"
  type        = string
  default     = "App-Server"
}
variable "webapp_location"{
  description = "Location to be established for WebApp"
  type        = string
  default     = "East US"
}
variable "resource_group_name" {
  description = "Resource group name in which appservice plan or appservice will be created. example- aa-ot-opshub-dev-east"
  type        = string
  default     = "SCCF-Test-Policy-Validation"
}
variable "keyvault_name" {
  description = "Name of keyvault used for retrieving/storing secrets"
  type        = string
  default     = null
}
variable "appservice" {
  description = "AppService name(s)"
  type        = any
  default     = {}
}
variable "appservice_slot" {
  description = "AppService slot name"
  type        = any
  default     = {}
}
variable "appservice_os_type" {
  description = "Appservice plan OS type. Example- Linux, windows"
  type        = string
  default     = "Windows"
}
variable "appservice_sku_name" {
  description = "Size of appservice plan. Example- S1, P1 etc"
  type        = string
  default     = "F1"
}
variable "appservice_plan_name" {
  description = "AppService plan name"
  type        = string
}
variable "appservice_plan_id" {
  description = "Existing AppService plan name in which appservice has to be created"
  type        = string
  default     = "WebApp-Test-Plan_id"
}
variable "existing_appservice_plan_name" {
  description = "Existing AppService plan name in which appservice has to be created"
  type        = string
  default     = ""

}
variable "identity_type" {
  type        = string
  description = "Type of manged service identity for the application"
  default     = "SystemAssigned"
}
variable "dynamic_app_settings" {
  type        = any
  description = "Any configurations whose values are retrieved during runtime"
  default     = {}
}
variable "custom_tags" {
  type        = any
  description = "Add any custom tags apart from the ones retrieved from parent RG"
  default     = {}
}
variable "https_only" {
  type       = bool
  description = "Set to true or false for restricting to https vs http"
  default     = true
}
variable "ftps_state" {
  type       = string
  description = "Set to FtpsOnly or Disabled"
  default     = "FtpsOnly"
}
variable "min_tls_version" {
  type       = number
  description = "Set minimum tls version"
  default     = 1.2
}
variable "always_on" {
  type       = bool
  description = "Is this Windows Web App is Always On enabled"
  default     = "false"
}
