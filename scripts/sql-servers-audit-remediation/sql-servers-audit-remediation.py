import os
import json
import time
import logging
import subprocess
import concurrent.futures
from azure.identity import DefaultAzureCredential
from azure.mgmt.managementgroups import ManagementGroupsAPI
from azure.mgmt.sql import SqlManagementClient
from azure.mgmt.policyinsights import PolicyInsightsClient
from azure.mgmt.resource import PolicyClient
from azure.mgmt.policyinsights.models import Remediation

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("sql-server-audit")  # Set logger name
logging.getLogger("azure").setLevel(logging.WARNING)

SQL_SERVER_FILE = 'sql_servers.json'
REFERENCE_ID_FILE = 'reference_id.json'

def save_servers_to_file(file_name, data):
    with open(file_name, 'w') as f:
        json.dump(data, f, indent=2)

def list_sql_servers(subscription_id, credential):
    sql_client = SqlManagementClient(credential, subscription_id)
    return list(sql_client.servers.list())

def list_subscriptions_under_management_group(management_group_id, credential):
    mgmt_client = ManagementGroupsAPI(credential)
    subscriptions = mgmt_client.management_group_subscriptions.get_subscriptions_under_management_group(management_group_id)
    return [subscription.name for subscription in subscriptions]

def get_sql_server_audit_policy(sql_server_name, resource_group_name, subscription_id):
    try:
        login_command = [
            "az", "login", "--service-principal", 
            "-u", os.environ.get("AZURE_CLIENT_ID"),
            "-p", os.environ.get("AZURE_CLIENT_SECRET"),
            "--tenant", os.environ.get("AZURE_TENANT_ID")
        ]
        subprocess.run(login_command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)  
        command = [
            "az", "sql", "server", "audit-policy", "show",
            "--name", sql_server_name,
            "--resource-group", resource_group_name,
            "--subscription", subscription_id,
            "--output", "json"
        ]

        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
        return json.loads(result.stdout)

    except subprocess.CalledProcessError as e:
        logger.error(f"Error fetching audit policy for {sql_server_name}: {e.stderr}")
        return {}

def process_subscription(mg_id, subscription_id, credential):
    servers = list_sql_servers(subscription_id, credential)
    server_data = []

    with concurrent.futures.ThreadPoolExecutor() as executor:
        future_to_server = {
            executor.submit(get_sql_server_audit_policy, server.name, server.id.split('/')[4], subscription_id): server 
            for server in servers
        }

        for future in concurrent.futures.as_completed(future_to_server):
            server = future_to_server[future]

            if server.id.split('/')[4].startswith("synapseworkspace-managedrg-") and server.kind == "v12.0,analytics":
                logger.info("Synapse workspace found, Skipping this SQL Server.")
            else:
                audit_policy = future.result()
                if (audit_policy.get('eventHubTargetState') == "Enabled" and 
                    audit_policy.get('eventHubName') != "azure-sqlaudit") or \
                audit_policy.get('eventHubTargetState') == "Disabled":
                    
                    server_data.append({
                        "management_group": mg_id,
                        "subscription_id": subscription_id,
                        "sql_server_name": server.name,
                        "server_id": server.id,
                        "sql_server_location": server.location,
                        "resource_group_name": server.id.split('/')[4],
                        "audit_policy": audit_policy
                    })

    return server_data

def get_policy_reference_ids_and_assignments(credential, subscription_id, management_group_id, policy_definition_name):
    policy_client = PolicyClient(credential, subscription_id)
    policy_set_details = policy_client.policy_set_definitions.get_at_management_group(policy_definition_name, management_group_id)
    policy_definition_id = policy_set_details.id
    policy_assignments = policy_client.policy_assignments.list_for_management_group(
        management_group_id=management_group_id,
        filter=f"policyDefinitionId eq '{policy_definition_id}'"
    )
    assignment_and_ref_ids = {}
    for assignment in policy_assignments:
        assignment_and_ref_ids['assignment_id'] = assignment.id
    assignment_and_ref_ids['reference_id_mapping'] = []
    for policy_definition in policy_set_details.policy_definitions:
        reference_id_details = {}
        reference_id_details['reference_id'] = policy_definition.policy_definition_reference_id
        reference_id_details['location'] = policy_definition.parameters['eventHubLocation'].value
        assignment_and_ref_ids['reference_id_mapping'].append(reference_id_details)

    return assignment_and_ref_ids

def create_remediation(credential, subscription_id, resource_id, remediation_name, policy_assignment_id, definition_reference_id):
    client = PolicyInsightsClient(credential, subscription_id)

    remediation_properties = Remediation(
        policy_assignment_id=policy_assignment_id,
        resource_discovery_mode="ExistingNonCompliant",
        policy_definition_reference_id=definition_reference_id
    )

    remediation = client.remediations.create_or_update_at_resource(
        resource_id=resource_id,
        remediation_name=remediation_name,
        parameters=remediation_properties
    )

    return remediation

def main():
    start_time = time.time()
    management_group_ids = ['AA_POLICY_TEST']
    #management_group_ids = ['AA_POLICY_TEST', 'NON-PRODUCTION-MG', 'PRODUCTION-MG']
    # below mapping "c575f23e-e421-4c45-ace0-2cb78dce631a" is captured from "policyset.json" under "Deploy SQL Server Auditing to CSTRM Eventhub" Initiative folder.
    management_group_policy_mapping = {
        "AA_POLICY_TEST": "c575f23e-e421-4c45-ace0-2cb78dce631a_D",
        "NON-PRODUCTION-MG": "c575f23e-e421-4c45-ace0-2cb78dce631a_N",
        "PRODUCTION-MG": "c575f23e-e421-4c45-ace0-2cb78dce631a"
    }
    credential = DefaultAzureCredential()
    all_server_data = []

    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        future_to_mg = {
            executor.submit(list_subscriptions_under_management_group, mg_id, credential): mg_id 
            for mg_id in management_group_ids
        }

        for future in concurrent.futures.as_completed(future_to_mg):
            mg_id = future_to_mg[future]
            subscription_list = future.result()

            for subscription_id in subscription_list:
                all_server_data.extend(process_subscription(mg_id, subscription_id, credential))

    if all_server_data:
        save_servers_to_file(SQL_SERVER_FILE, all_server_data)

    subscription_id = "55f702f9-17ee-4d42-8da3-3f0bc97c4158"
    mg_to_assignments = {}
    for mg_id in management_group_ids:
        mg_to_assignment = {}
        policy_definition_name = management_group_policy_mapping[mg_id] 
        assignment_and_ref_ids = get_policy_reference_ids_and_assignments(credential, subscription_id, mg_id, policy_definition_name)
        mg_to_assignment['mapping_details'] = assignment_and_ref_ids
        mg_to_assignments[mg_id] = mg_to_assignment
    
    if mg_to_assignments:
        save_servers_to_file(REFERENCE_ID_FILE, mg_to_assignments)

    for index, server_data in enumerate(all_server_data):
        subscription_id = server_data['subscription_id']
        resource_id = server_data['server_id']
        remediation_name = f"sql_server_remediation_{index}"
        policy_assignment_id = mg_to_assignments[server_data['management_group']]['mapping_details']['assignment_id']
        definition_reference_id = None
        for mapping in mg_to_assignments[server_data['management_group']]['mapping_details']['reference_id_mapping']:
            if mapping['location'] == server_data['sql_server_location']:
                definition_reference_id = mapping['reference_id']
                break
        result = create_remediation(credential, subscription_id, resource_id, remediation_name, policy_assignment_id, definition_reference_id)
        logger.info(f"Remediation created for {resource_id} with remediation name {remediation_name}.")

    end_time = time.time()
    execution_time = end_time - start_time
    logger.info(f"Execution time: {execution_time}")

if __name__ == "__main__":
    main()