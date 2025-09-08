variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "fileset_filter" {
  description = "Regex used to determine the assignment files used for target environment"
  type        = string
}

variable "path_to_dir" {
  description = "path to the policy directory"
  type        = string
}

variable "policy_desc" {
  description = "description of the policy"
  type        = string
}

variable "policy_id" {
  description = "Id for the policy"
  type        = string
}

variable "with_remediation" {
  default     = false
  description = "Does this policy require remediation?"
  type        = bool
}

