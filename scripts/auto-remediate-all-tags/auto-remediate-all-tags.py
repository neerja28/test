import time
import json
from azure.identity import DefaultAzureCredential
from azure.mgmt.policyinsights import PolicyInsightsClient
from azure.mgmt.resource.policy import PolicyClient
from datetime import datetime


def get_policy_definition_reference_ids(policy_client, management_group_id, policy_set_name):
    """
    Retrieve policy definition reference IDs from a given policy set name at the management group level.
    """
    print(f"[INFO] Fetching policy set definition '{policy_set_name}' for management group ID: {management_group_id}")
        
    # Fetch the specific policy set definition using get_at_management_group
    try:
        policy_set = policy_client.policy_set_definitions.get_at_management_group(management_group_id, policy_set_name)
    except Exception as e:
        print(f"[ERROR] Failed to fetch policy set definition '{policy_set_name}' for management group '{management_group_id}': {e}")
        return []
    
    # Extract policy definition reference IDs
    reference_ids = []
    for policy_definition in policy_set.policy_definitions:
        reference_id = policy_definition.policy_definition_reference_id
        reference_ids.append({
            "policy_definition_id": policy_definition.policy_definition_id,
            "reference_id": reference_id
        })
    
    return reference_ids

def create_remediation_at_management_group(policy_insights_client, management_group_id, policy_assignment_id, policy_definition_reference_id):
    """
    Create a remediation task at the management group level.
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    remediation_name = f"remediation_{policy_definition_reference_id}_{timestamp}"
    remediation_parameters = {
        "policy_assignment_id": policy_assignment_id,
        "policy_definition_reference_id": policy_definition_reference_id,
        "resource_discovery_mode": "ExistingNonCompliant",
        "resource_count": 50000
    }

    # Initiate remediation task
    try:
        remediation = policy_insights_client.remediations.create_or_update_at_management_group(
            management_group_id=management_group_id,
            remediation_name=remediation_name,
            parameters=remediation_parameters
        )
        print(f"[INFO] Started remediation: {remediation_name}")
        return {
            "management_group_id": management_group_id,
            "remediation_name": remediation_name
        }
    except Exception as e:
        print(f"[ERROR] Failed to create remediation for reference ID '{policy_definition_reference_id}' in MG '{management_group_id}': {e}")
        return None
    
def track_remediation_status_at_management_group(policy_insights_client, management_group_id, remediation_name):
    """
    Track a remediation task at the management group level.
    """
    remediation_task_id = f"/providers/Microsoft.Management/managementGroups/{management_group_id}/providers/Microsoft.PolicyInsights/remediations/{remediation_name}"
    remediation_task_url = f"https://portal.azure.com/#@amrcorp.onmicrosoft.com/resource{remediation_task_id}/overview"

    retry_count = 0
    max_retries = 10

    while True:
        try:
            remediation = policy_insights_client.remediations.get_at_management_group(
                management_group_id, remediation_name
            )
            state = remediation.provisioning_state
            print(f"[STATUS] {remediation_name} → {state}")

            if state.lower() != "running":
                deployment_status = remediation.deployment_status
                deployment_summary = {
                    "total_deployments": deployment_status.total_deployments,
                    "successful_deployments": deployment_status.successful_deployments,
                    "failed_deployments": deployment_status.failed_deployments
                } if deployment_status else {}

                return {
                    "remediation_task_id": remediation_task_id,
                    "remediation_task_url": remediation_task_url,
                    "management_group": management_group_id,
                    "remediation_state": state,
                    "deployment_status": deployment_summary
                }

            retry_count = 0  # reset retry counter on success

        except Exception as e:
            retry_count += 1
            print(f"[WARNING] Failed to fetch status for {remediation_name}: {e}")
            if retry_count > max_retries:
                print(f"[ERROR] Max retries exceeded for {remediation_name}. Skipping.")
                return {
                    "remediation_task_id": remediation_task_id,
                    "remediation_task_url": remediation_task_url,
                    "management_group": management_group_id,
                    "remediation_state": "Unknown (Failed to retrieve status)",
                    "deployment_status": "Unknown (Failed to retrieve status)"
                }

        time.sleep(30)


def main():
    start_time = time.time()
    # Initialize credentials and clients
    credential = DefaultAzureCredential()
    policy_client = PolicyClient(credential, "55f702f9-17ee-4d42-8da3-3f0bc97c4158")
    policy_insights_client = PolicyInsightsClient(credential, "55f702f9-17ee-4d42-8da3-3f0bc97c4158")

    # Define your policy sets with assignment names
    policy_sets = {
        "resource_groups_policy_set_criticality": {
            "policy_set_name": "792c620c-22e7-42ea-973e-38ae058be4e1",
            "assignments": {
                "production-mg": "GaaSPolicyUFnfLlb6In0AGT",
                "non-production-mg": "GaaSPolicyDQJI20p8RJiUQU",
                "aa_policy_test": "GaaSPolicyaOGHbeG9s6IDqR"
            }
        },
        "resource_policy_set_criticality": {
            "policy_set_name": "583c81aa-484d-466d-9049-18bdd98455f8",
            "assignments": {
                "production-mg": "GaaSPolicy8zDjSJrxsaNSpb",
                "non-production-mg": "GaaSPolicyJBgyni7gwvsqMc",
                "aa_policy_test": "GaaSPolicyAgQx8wT2q6kRPy"
            }
        },
        "resource_policy_set_aa_std_tags": {
            "policy_set_name": "60f1378c-8055-43de-9375-a84194b8f8d6",
            "assignments": {
                "production-mg": "GaaSPolicygHcV4XO2uOMPk7",
                "non-production-mg": "GaaSPolicypkKLl7K6atHcPG",
                "aa_policy_test": "GaaSPolicy0ogVOr9cqAERxO"
            }
        }
    }

    # Iterate through policy sets and run remediation tasks
    remediation_tasks = []
    for policy_set_key, policy_set_details in policy_sets.items():
        base_policy_set_name = policy_set_details["policy_set_name"]
        assignments = policy_set_details["assignments"]

        for mg_scope_name, assignment_name in assignments.items():
            # Adjust policy_set_name based on the management group
            if mg_scope_name == "non-production-mg":
                policy_set_name = f"{base_policy_set_name}_N"
            elif mg_scope_name == "aa_policy_test":
                policy_set_name = f"{base_policy_set_name}_D"
            else:
                policy_set_name = base_policy_set_name

            management_group_id = mg_scope_name  # The management group ID corresponds to the assignment scope name

            # Get all policy definition reference IDs within the policy set using get_at_management_group
            policy_definition_references = get_policy_definition_reference_ids(policy_client, management_group_id, policy_set_name)

            # Construct the full policy assignment ID for the management group
            policy_assignment_id = f"/providers/Microsoft.Management/managementGroups/{management_group_id}/providers/Microsoft.Authorization/policyAssignments/{assignment_name}"

            for policy_def in policy_definition_references:
                policy_definition_reference_id = policy_def["reference_id"]

                # Create a remediation task for each policy definition reference ID
                result = create_remediation_at_management_group(
                    policy_insights_client, 
                    management_group_id, 
                    policy_assignment_id, 
                    policy_definition_reference_id
                )
                if result:
                    remediation_tasks.append(result)

    time.sleep(30)
    final_report = []
    for task in remediation_tasks:
        status = track_remediation_status_at_management_group(
            policy_insights_client, task["management_group_id"], task["remediation_name"]
        )
        final_report.append(status)

    print("\nFinal Remediation Report:")
    for report_details in final_report:
        print(report_details)

    with open("remediation_report.json", "w") as f:
        json.dump(final_report, f, indent=2)
    print("\n Remediation report written to remediation_report.json")

    end_time = time.time()
    total_duration = end_time - start_time
    print(f"\n Total script runtime: {total_duration:.2f} seconds")

if __name__ == "__main__":
    main()