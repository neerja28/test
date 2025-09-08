resource "azurerm_policy_definition" "policy_definition" {
  description         = "${var.display_name_prefix}${jsondecode(file("${var.path_to_def}/policy.json")).properties.description}"
  display_name        = "${var.display_name_prefix}${jsondecode(file("${var.path_to_def}/policy.json")).properties.displayName}"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  mode                = jsondecode(file("${var.path_to_def}/policy.json")).properties.mode
  name                = "${jsondecode(file("${var.path_to_def}/policy.json")).name}${var.name_suffix}"
  policy_rule         = jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.policyRule)
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
      can(jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.metadata))
      ? jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.metadata) != jsonencode({})
      : false
    )
    ? jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.metadata)
    : ""
  )
  parameters = (
    (
      can(jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.parameters))
      ? jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.parameters) != jsonencode({})
      : false
    )
    ? jsonencode(jsondecode(file("${var.path_to_def}/policy.json")).properties.parameters)
    : ""
  )
}

output "id" {
  value = azurerm_policy_definition.policy_definition.id
}
