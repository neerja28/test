variable "display_name_prefix" {
  description = "prefix to display name to indicate environment"
  type        = string
}

variable "fileset_filter" {
  description = "Regex used to determine the assignment files used for target environment"
  type        = string
}

variable "policy_ids" {
  description = "IDs of the policy intitatives"
}

variable "path_to_initiatives" {
  description = "path to the folder containing the inititatives"
  type        = string
}
