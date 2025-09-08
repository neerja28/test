variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "environment" {
  default     = "Dev"
  description = "Environment used (Dev | NonProd | Prod)"
  type        = string
}

variable "management_group_id" {
  description = "name of management group scope for policy definition"
  type        = string
}

variable "name_suffix" {
  description = "suffix of name to indicate environment"
  type        = string
}

variable "path_to_def" {
  description = "path to the folder containing the policies"
  type        = string
}

variable "policy_ids" {
  description = "Ids of the policies used by the initiatives"
}
