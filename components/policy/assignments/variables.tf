variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "fileset_filter" {
  description = "Regex used to determine the assignment files used for target environment"
  type        = string
}

variable "policy_ids" {
  description = "Id for the policy definitions"
}

variable "path_to_policies" {
  description = "path to the folder containing the policies"
  type        = string
}
