resource "azurerm_role_assignment" "assignment" {
  for_each             = toset(jsondecode(file("${var.file_name}")).identity.roleAssignments)
  role_definition_name = split(":", each.key)[0]
  scope                = try(split(":", each.key)[1], jsondecode(file("${var.file_name}")).properties.scope)
  principal_id         = var.principal_id
}
