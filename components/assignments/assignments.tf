module "helper" {
  for_each = fileset(var.path_to_dir, var.fileset_filter)

  display_name_prefix = var.display_name_prefix
  file_name           = "${var.path_to_dir}/${each.value}"
  policy_desc         = var.policy_desc
  policy_id           = var.policy_id
  with_remediation    = var.with_remediation

  source = "./helper"
}
