locals {
  scope = jsondecode(file(var.file_name)).properties.scope
}

module "management_group" {
  count = (
    length(regexall("(?i)/managementGroups/", local.scope)) > 0
    ? 1
    : 0
  )

  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name
  policy_desc         = var.policy_desc
  policy_id           = var.policy_id
  with_remediation    = var.with_remediation

  source = "../management_group"
}

module "resource_group" {
  count = (
    length(regexall("(?i)/resourceGroups/", local.scope)) > 0
    ? 1
    : 0
  )

  display_name_prefix = var.display_name_prefix
  file_name           = var.file_name
  policy_desc         = var.policy_desc
  policy_id           = var.policy_id
  with_remediation    = var.with_remediation

  source = "../resource_group"
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
  policy_desc         = var.policy_desc
  policy_id           = var.policy_id
  with_remediation    = var.with_remediation

  source = "../subscription"
}
