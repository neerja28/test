import json
import sys
import os
import logging
from ..github_interactions import *

# Configure the logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("enforcement_policy_updater")  # Set logger name

def main():
    # Read the compliance status and resource types from files
    with open('scripts/azure-block-unused-resources/all_policies_compliant.json', 'r') as f:
        all_policies_compliant = json.load(f)

    try:
        with open('scripts/azure-block-unused-resources/resource_types_to_update.json', 'r') as f:
            resource_types_to_update = json.load(f)
    except FileNotFoundError:
        resource_types_to_update = None

    # Check if policy_version file exists
    policy_version = None
    try:
        with open('scripts/azure-block-unused-resources/policy_version.json', 'r') as f:
            policy_version = json.load(f)
    except FileNotFoundError:
        logger.info("Policy version file not found. Skipping final schema update.")

    # If all policies are compliant, proceed with updating the enforcement policy files
    if all_policies_compliant and resource_types_to_update:
        enforcement_policy_details = {
            "enforcement_policy_paths": [
                {
                    "policy_path": "azure/policies/unused-services/Restrict creation of unused azure services/assign.dev.AA_POLICY_TEST.json"
                },
                {
                    "policy_path": "azure/policies/unused-services/Restrict creation of unused azure services/assign.np.NON-PRODUCTION-MG.json"
                },
                {
                    "policy_path": "azure/policies/unused-services/Restrict creation of unused azure services/assign.p.PRODUCTION-MG.json"
                }
            ]
        }

        git_repo = os.getenv('GIT_REPO')
        owner, repo_name = git_repo.split('/')
        source_branch = "nonprod"
        target_branch = "update-enforcement-policies"  # Example branch, replace as needed
        pr_title = "chore: Auto Updating Azure Unused Services Enforcement Policies"
        pr_body_string = "This PR updates the enforcement policies with the resource types that are compliant as per the audit policies."

        # Close any existing PR and delete the branch if it exists
        close_pr(owner, repo_name, pr_title)
        delete_branch(owner, repo_name, target_branch)

        # Create the branch before making any updates
        create_branch(source_branch, target_branch, owner, repo_name)

        # Update the enforcement policy files on the new branch
        for path in enforcement_policy_details["enforcement_policy_paths"]:
            enforcement_policy = get_git_policy_json(owner, repo_name, path["policy_path"], branch_name="main")
            enforcement_policy["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"] = resource_types_to_update
            commit_comment = f'Update enforcement policy {path["policy_path"]}'
            update_policy_file(owner, repo_name, path["policy_path"], enforcement_policy, target_branch, commit_comment)
            logger.info(f"Updated policy at {path['policy_path']} with new resource types.")

        # If the policy_version exists, check for the interim schema file and update the final schema
        if policy_version:
            interim_schema_file_path = f'scripts/azure-block-unused-resources/input_output/final_schema_interim_{policy_version}.json'
            final_schema_file_path = 'scripts/azure-block-unused-resources/input_output/final_schema.json'

            if os.path.exists(interim_schema_file_path):
                try:
                    with open(interim_schema_file_path, 'r') as f:
                        interim_schema = json.load(f)

                    # Update the final_schema.json file using the update_policy_file function
                    commit_comment = f"Updated {final_schema_file_path} with content from {interim_schema_file_path}"
                    update_policy_file(owner, repo_name, final_schema_file_path, interim_schema, target_branch, commit_comment)
                    logger.info(f"Updated {final_schema_file_path} with content from {interim_schema_file_path}.")

                    # Delete the interim schema file using the delete_file function
                    delete_commit_comment = f"Deleted {interim_schema_file_path} after updating final schema."
                    delete_file(owner, repo_name, interim_schema_file_path, target_branch, delete_commit_comment)
                    logger.info(f"Deleted {interim_schema_file_path} after updating final schema.")
                except Exception as e:
                    logger.error(f"Error updating final schema: {e}")
            else:
                logger.info(f"Interim schema file {interim_schema_file_path} not found. Skipping final schema update.")
        else:
            logger.info("Policy version not found or no valid interim schema file exists.")

        # Raise a PR
        raise_pr(source_branch, target_branch, owner, repo_name, pr_title, pr_body_string)

        logger.info("Changes have been made on the new branch and a PR has been raised.")
    else:
        logger.info("No changes to be made, either the policies are not compliant or there are no resources to update.")
        sys.exit(1)  # Exit with failure code if the condition is not met

if __name__ == "__main__":
    main()
