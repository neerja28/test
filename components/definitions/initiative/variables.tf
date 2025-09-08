variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "management_group_id" {
  description = "id of management group scope for policy definition"
  type        = string
}

variable "name_suffix" {
  description = "suffix used for the name to indicate environment"
  type        = string
}

variable "path_to_def" {
  description = "path to the policy directory"
  type        = string
}

variable "policy_references" {
  description = "reference for policy definitions used in initiative definition"
}
