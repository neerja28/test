module "helper" {
  for_each = fileset(var.path_to_def, var.ex_fileset_filter)

  display_name_prefix = var.display_name_prefix
  file_name           = "${var.path_to_def}/${each.value}"
  source = "./helper"
}

