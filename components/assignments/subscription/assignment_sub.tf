resource "azurerm_subscription_policy_assignment" "policy_assignment_sub" {
  name                 = jsondecode(file("${var.file_name}")).name
  subscription_id      = jsondecode(file("${var.file_name}")).properties.scope
  not_scopes           = jsondecode(file("${var.file_name}")).properties.notScopes
  policy_definition_id = var.policy_id
  description          = var.policy_desc
  display_name         = "${var.display_name_prefix}${jsondecode(file("${var.file_name}")).properties.displayName}"
  enforce              = (jsondecode(file("${var.file_name}")).properties.enforcementMode == "Default" || jsondecode(file("${var.file_name}")).properties.enforcementMode == "true")
  metadata             = jsonencode(jsondecode(file("${var.file_name}")).properties.metadata)
  parameters           = jsondecode(file("${var.file_name}")).properties.parameters != {} ? jsonencode(jsondecode(file("${var.file_name}")).properties.parameters) : null
  location             = can(jsondecode(file("${var.file_name}")).location) ? jsondecode(file("${var.file_name}")).location : ""
  dynamic "identity" {
    for_each = can(jsondecode(file("${var.file_name}")).identity.type) ? toset([jsondecode(file("${var.file_name}")).identity.type]) : []
    content {
      type = identity.value
    }
  }
  dynamic "non_compliance_message"  {
    for_each = can(jsondecode(file("${var.file_name}")).properties.nonComplianceMessages) ? toset(jsondecode(file("${var.file_name}")).properties.nonComplianceMessages) : []
    content {
      content = non_compliance_message.value
    } 
  }
}

module "role_assignments" {
  count        = (length(try(jsondecode(file("${var.file_name}")).identity.roleAssignments, [])) > 0) ? 1 : 0
  file_name    = var.file_name
  principal_id = azurerm_subscription_policy_assignment.policy_assignment_sub.identity[0].principal_id
  source       = "../roles"
}

resource "azurerm_subscription_policy_remediation" "policy_remediation_sub_no_roles" {
  count                = var.with_remediation && (length(try(jsondecode(file("${var.file_name}")).identity.roleAssignments, [])) == 0) ? 1 : 0
  name                 = azurerm_subscription_policy_assignment.policy_assignment_sub.name
  subscription_id      = azurerm_subscription_policy_assignment.policy_assignment_sub.subscription_id
  policy_assignment_id = azurerm_subscription_policy_assignment.policy_assignment_sub.id
  location_filters     = []
}

resource "azurerm_subscription_policy_remediation" "policy_remediation_sub_with_roles" {
  count = var.with_remediation && ((length(try(jsondecode(file("${var.file_name}")).identity.roleAssignments, [])) > 0)) ? 1 : 0
  depends_on = [
    module.role_assignments
  ]
  name                 = azurerm_subscription_policy_assignment.policy_assignment_sub.name
  subscription_id      = azurerm_subscription_policy_assignment.policy_assignment_sub.subscription_id
  policy_assignment_id = azurerm_subscription_policy_assignment.policy_assignment_sub.id
  location_filters     = []
}
