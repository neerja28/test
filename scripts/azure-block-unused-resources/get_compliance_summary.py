import json
import sys
from azure.identity import DefaultAzureCredential
from azure.mgmt.policyinsights import PolicyInsightsClient
from azure.mgmt.policyinsights.models import QueryOptions
import logging
from ..github_interactions import *

# Configure the logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("policy_compliance_checker")  # Set logger name
logging.getLogger("azure").setLevel(logging.WARNING)

def get_compliance_summary_for_specific_assignment(management_group_name, policy_assignment_id, credential):
    policy_client = PolicyInsightsClient(credential, '55f702f9-17ee-4d42-8da3-3f0bc97c4158')
    
    # Set query options to filter by PolicyAssignmentId
    query_options = QueryOptions(filter=f"policyAssignmentId eq '{policy_assignment_id}'")

    # Summarize policy compliance for the specific policy assignment within the management group
    summary = policy_client.policy_states.summarize_for_management_group(
        management_group_name=management_group_name,
        query_options=query_options
    )
    return summary

def main():
    credential = DefaultAzureCredential()
    git_repo = os.getenv('GIT_REPO')
    owner, repo_name = git_repo.split('/')
    audit_policy_details = {
        "audit_policy_paths": [
            {
                "policy_path": "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.dev.AA_POLICY_TEST.json"
            },
            {
                "policy_path": "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.np.NON-PRODUCTION-MG.json"
            },
            {
                "policy_path": "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.p.PRODUCTION-MG.json"
            }
        ]
    }

    all_policies_compliant = True
    resource_types_to_update = None
    policy_version = None

    # Check compliance for each policy
    for path in audit_policy_details["audit_policy_paths"]:
        policy_details = get_git_policy_json(owner, repo_name, path["policy_path"], branch_name="main")
        management_group_name = policy_details["properties"]["scope"].split('/')[-1]
        if "version" in policy_details["properties"]["metadata"]:
            policy_version = policy_details["properties"]["metadata"]["version"]
        policy_assignment_name = policy_details["name"]
        policy_assignment_id = f'/providers/microsoft.management/managementgroups/{management_group_name}/providers/microsoft.authorization/policyassignments/{policy_assignment_name}'
        compliance_summary = get_compliance_summary_for_specific_assignment(management_group_name, policy_assignment_id, credential)
    
        for value in compliance_summary.value:
            non_compliant_policies = value.results.non_compliant_policies
            non_compliant_resources = value.results.non_compliant_resources

            logger.info(f"Management Group: {management_group_name}")
            logger.info(f"Policy Assignment: {policy_assignment_name}")
            logger.info(f"Non Compliant Policies: {non_compliant_policies}")
            logger.info(f"Non Compliant Resources: {non_compliant_resources}")

            if non_compliant_policies > 0:
                all_policies_compliant = False

    with open('scripts/azure-block-unused-resources/all_policies_compliant.json', 'w') as f:
        json.dump(all_policies_compliant, f, indent=2)
    logger.info("all_policies_compliant.json file created")

    if all_policies_compliant:
        # Capture the list of resources under listOfResourceTypesNotAllowed
        resource_types_to_update = policy_details["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"]
        with open('scripts/azure-block-unused-resources/resource_types_to_update.json', 'w') as f:
            json.dump(resource_types_to_update, f, indent=2)
        logger.info("resource_types_to_update.json file created")
        
        if policy_version:
            with open('scripts/azure-block-unused-resources/policy_version.json', 'w') as f:
                json.dump(policy_version, f, indent=2)
            logger.info("policy_version.json file created")

if __name__ == "__main__":
    main()
