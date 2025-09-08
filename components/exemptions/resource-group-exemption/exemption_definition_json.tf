resource "azurerm_resource_group_policy_exemption" "exemption_definition" {
  description                     = jsondecode(file("${var.file_name}")).properties.description
  display_name                    = "${var.display_name_prefix}${jsondecode(file("${var.file_name}")).properties.displayName}"
  name                            = jsondecode(file("${var.file_name}")).name
  resource_group_id               = jsondecode(file("${var.file_name}")).scope
  policy_assignment_id            = jsondecode(file("${var.file_name}")).properties.policyAssignmentId
  exemption_category              = jsondecode(file("${var.file_name}")).properties.exemptionCategory
  policy_definition_reference_ids = jsondecode(file("${var.file_name}")).properties.policyDefinitionReferenceId
  expires_on = (
    (
      can("${jsondecode(file("${var.file_name}")).properties.expiresOn}")
      ? "${jsondecode(file("${var.file_name}")).properties.expiresOn}" != jsonencode({})
      : false
    )
    ? "${jsondecode(file("${var.file_name}")).properties.expiresOn}"
    : null
  )

  metadata = (
    (
      can(jsonencode(jsondecode(file("${var.file_name}")).properties.metadata))
      ? jsonencode(jsondecode(file("${var.file_name}")).properties.metadata) != jsonencode({})
      : false
    )
    ? jsonencode(jsondecode(file("${var.file_name}")).properties.metadata)
    : ""
  )
}

output "id" {
  value = azurerm_resource_group_policy_exemption.exemption_definition.id
}
