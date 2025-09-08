variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "ex_fileset_filter" {
  description = "Regex used to determine the exemption files used for target environment"
  type        = string
}

variable "path_to_def" {
  description = "path to the policy directory"
  type        = string
}


