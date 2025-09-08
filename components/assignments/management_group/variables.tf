variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "file_name" {
  description = "File describing the assignment we are adding."
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
