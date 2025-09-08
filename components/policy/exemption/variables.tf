variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "ex_fileset_filter" {
  description = "Regex used to determine the exemption files used for target environment"
  type        = string
}

variable "name_suffix" {
  description = "suffix to name to indicate environment"
  type        = string
}

