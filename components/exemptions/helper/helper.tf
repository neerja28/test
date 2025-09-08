locals {
  scope = jsondecode(file(var.file_name)).scope
}

module "management_group" {
  count = (
    length(regexall("(?i)/managementGroups/", local.scope)) > 0
    ? 1
    : 0
  )

  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name

  source = "../management-group-exemption"
}

module "subscription" {
  count = (
    (
      length(regexall("(?i)/subscriptions/", local.scope)) > 0
      && length(regexall("(?i)/resourceGroups/", local.scope)) < 1
    )
    ? 1
    : 0
  )

  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name

  source = "../subscription-exemption"
}

module "resource_group" {
  count = (
    (
      length(regexall("(?i)/resourceGroups/", local.scope)) > 0
      && length(regexall("(?i)/providers/", local.scope)) < 1
    )
    ? 1
    : 0
  )
  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name

  source = "../resource-group-exemption"
}

module "resource" {
  count = (
    (
      length(regexall("(?i)/resourceGroups/", local.scope)) > 0
      && length(regexall("(?i)/providers/", local.scope)) > 0
    )
    ? 1
    : 0
  )

  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name

  source = "../resource-exemption"
}