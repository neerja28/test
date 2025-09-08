from azure.identity import DefaultAzureCredential
from azure.mgmt.authorization import AuthorizationManagementClient
import requests
import pandas as pd
import logging
from collections import defaultdict

credential = DefaultAzureCredential()
subscription_id = "ADD_YOUR_SUBSCRIPTION_ID_HERE"  # Replace with your subscription I
client = AuthorizationManagementClient(credential, subscription_id)
principal_cache = {}

def get_graph_token():
    """Get a token to call Microsoft Graph."""
    try:
        token = credential.get_token("https://graph.microsoft.com/.default")
        return token.token
    except Exception as e:
        logging.error(f"Failed to get Graph token: {e}")
        return None

def get_principal_display_name(principal_id):
    """Get principal display name from principal ID""" 
    if principal_id in principal_cache:
        return principal_cache[principal_id]

    GRAPH_API_URL = "https://graph.microsoft.com/v1.0"
    headers = {"Authorization": f"Bearer {get_graph_token()}"}

    for principal_type in ["users", "groups", "servicePrincipals"]:
        url = f"{GRAPH_API_URL}/{principal_type}/{principal_id}"
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            name = data.get("displayName") or data.get("appDisplayName", "Unknown")
            principal_cache[principal_id] = name
            return name
    principal_cache[principal_id] = "Unknown"
    return "Unknown"

def get_role_name_from_id(role_definition_id, authorization_client):
    role_def_id = role_definition_id.split('/')[-1]  # Extract GUID
    scope = '/subscriptions/' + subscription_id
    try:
        role_definition = authorization_client.role_definitions.get(scope, role_def_id)
        # Check if role_definition has properties
        if hasattr(role_definition, 'properties'):
            return role_definition.properties.role_name
        # If properties is not available, use role_name directly
        if hasattr(role_definition, 'role_name'):
            return role_definition.role_name
        # If neither is available, return a default value
        logging.warning(f"Role definition does not have expected properties: {role_definition}")
        if hasattr(role_definition, 'role_name'):
            return role_definition.role_name
        else:
            logging.warning(f"Role definition does not have expected properties: {role_definition}")
            return "Unknown"
    except Exception as e:
        logging.warning(f"Failed to fetch role name for {role_definition_id}: {e}")
        return "Unknown"

def get_role_assignment_count(subscription_id):
    authorization_client = AuthorizationManagementClient(credential, subscription_id)
    scope = f'/subscriptions/{subscription_id}'
    role_assignments = authorization_client.role_assignments.list_for_scope(scope)
    role_assignments_list = list(role_assignments)
    counts = defaultdict(int)
    assignments_data = []

    for role in role_assignments_list:
        role_scope = role.scope.lower()
        role_name = get_role_name_from_id(role.role_definition_id, authorization_client)
        principal_display_name= get_principal_display_name(role.principal_id)
        
        if role_scope == f'/subscriptions/{subscription_id}'.lower():
            counts['subscription'] += 1
            assignments_data.append({
            'type': role.type,
            'id': role.id,
            'name': role.name,
            'scope': role.scope,
            'role_definition_id': role.role_definition_id,
            'role_name': role_name, 
            'principal_id': role.principal_id,
            'principal_display_name': principal_display_name,
            'principal_type': role.principal_type,
            'description': role.description,
            'condition': role.condition,
            'condition_version': role.condition_version,
            'created_by': role.created_by,
            'updated_by': role.updated_by,
            'delegated_managed_identity_resource_id': role.delegated_managed_identity_resource_id
         })
        elif '/resourcegroups/' in role_scope:
            counts['resource_group'] += 1
            assignments_data.append({
            'type': role.type,
            'id': role.id,
            'name': role.name,
            'role_definition_id': role.role_definition_id,
            'role_name': role_name, 
            'principal_id': role.principal_id,
            'principal_display_name': principal_display_name,
            'principal_type': role.principal_type,
            'description': role.description,
            'condition': role.condition,
            'condition_version': role.condition_version,
            'created_by': role.created_by,
            'updated_by': role.updated_by,
            'delegated_managed_identity_resource_id': role.delegated_managed_identity_resource_id
         })

    total = counts['subscription'] + counts['resource_group']
    return counts, total, assignments_data

def export_to_excel(data, filename='role_assignments_corp_nonprod.xlsx'):
    """Export the list of role assignment dictionaries to an Excel file."""
    df = pd.DataFrame(data)
    df.to_excel(filename, index=False)
    logging.info(f"Exported role assignment data to {filename}")

def main():
    if subscription_id:
        breakdown, total, assignments_data = get_role_assignment_count(subscription_id)
        print(f"\nRole Assignment Breakdown for Subscription ID: {subscription_id}")
        print(f"  Number of role assignments for this subscription : {total}")
        print(f"  At Subscription Level: {breakdown['subscription']}")
        print(f"  At Resource Group Level: {breakdown['resource_group']}")
        # Export to Excel
        export_to_excel(assignments_data)
        print(f"Exported role assignment data to role_assignments.xlsx")
        
    else:
        print("No subscription ID provided. Please provide a valid subscription ID.")
 
if __name__ == "__main__":
    main()