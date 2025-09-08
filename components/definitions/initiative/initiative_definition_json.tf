resource "azurerm_policy_set_definition" "initiative_definition" {
  description         = "${var.display_name_prefix}${jsondecode(file("${var.path_to_def}/policyset.json")).properties.description}"
  display_name        = "${var.display_name_prefix}${jsondecode(file("${var.path_to_def}/policyset.json")).properties.displayName}"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  name                = "${jsondecode(file("${var.path_to_def}/policyset.json")).name}${var.name_suffix}"
  policy_type         = "Custom"

  # The complexity of the next section is due to the complexity of the requirements and the limitations of the Terraform scripting language.
  # The logic is approximately:
  #   if (the prod attribute exists in the json file AND the prod attribute is not an empty json structure) {
  #     return the value from the json attribute
  #   } else {
  #     return an empty string
  #   }

  metadata = (
    (
      can(jsonencode(jsondecode(file("${var.path_to_def}/policyset.json")).properties.metadata))
      ? jsonencode(jsondecode(file("${var.path_to_def}/policyset.json")).properties.metadata) != jsonencode({})
      : false
    )
    ? jsonencode(jsondecode(file("${var.path_to_def}/policyset.json")).properties.metadata)
    : ""
  )

  dynamic "policy_definition_reference" {
    for_each = var.policy_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values = (
        (
          can(policy_definition_reference.value.parameter_values)
          ? policy_definition_reference.value.parameter_values != jsonencode({})
          : false
        )
        ? policy_definition_reference.value.parameter_values
        : jsonencode({})
      )
    }
  }
}

output "id" {
  value = azurerm_policy_set_definition.initiative_definition.id
}
