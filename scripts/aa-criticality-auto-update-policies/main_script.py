import os
from ..github_interactions import *
from ..archer_interactions import *
import logging

# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("aa-criticality-automation")  # Set logger name

# Logic to update policy
def update_files_branch(app_criticality_dict, target_branch, owner, repo_name, commit_comment, policy_base_path, criticality_levels):
    try:
        for criticality in criticality_levels:
            policy_path = f"{policy_base_path}{criticality}/policy.json"
            app_list = app_criticality_dict[criticality]
            policy_file = get_git_policy_json(owner, repo_name, policy_path, target_branch)
            policy_file["properties"]["parameters"]["tagValue"]["defaultValue"] = app_list
            update_policy_file(owner, repo_name, policy_path, policy_file, target_branch, commit_comment)
    except Exception as e:
        logger.error("Error while updating files: {}".format(e))
        raise e
    
# Function to segregate aa-app-shortname based to their respective aa-criticality.
def categorize_applications(applications):
    vital_apps = []
    critical_apps = []
    important_apps = []
    discretionary_apps = []

    for app in applications:
        shortname = app.get("shortname")
        criticality = app.get("criticality")
        status = app.get("status")

        if status in ["Active", "In Development"]:
            if criticality == "Vital":
                vital_apps.append(shortname)
            elif criticality == "Critical":
                critical_apps.append(shortname)
            elif criticality == "Important":
                important_apps.append(shortname)
            elif criticality == "Discretionary":
                discretionary_apps.append(shortname)
        
            # Sort the lists
            vital_apps = sorted(vital_apps, key=lambda x: (x.lower(), x))
            critical_apps = sorted(critical_apps, key=lambda x: (x.lower(), x))
            important_apps = sorted(important_apps, key=lambda x: (x.lower(), x))
            discretionary_apps = sorted(discretionary_apps, key=lambda x: (x.lower(), x))

    return {
        "vital": vital_apps,
        "critical": critical_apps,
        "important": important_apps,
        "discretionary": discretionary_apps
    }

def process_branch(app_criticality_dict, source_branch, target_branch, owner, repo_name, pr_title, commit_comment):
    # Check if there is currently a PR in place with same pr_title, if yes, get the branch details.
    branch_name = get_child_branch(owner, repo_name, pr_title)

    # Logic to get list of current aa-app-shortnames from the policies.
    policy_base_path = "azure/policies/tags/Modify auto tag ResourceGroups with aa-criticality tag - "
    criticality_levels = ["vital", "critical", "important", "discretionary"]
    policy_jsons = {}
    app_short_name = {}
    for criticality in criticality_levels:
        policy_path = f"{policy_base_path}{criticality}/policy.json"
        if branch_name.startswith(target_branch):
            policy_json = get_git_policy_json(owner, repo_name, policy_path, branch_name)
        elif branch_name == "":
            policy_json = get_git_policy_json(owner, repo_name, policy_path)
        else:
            return
        policy_jsons[criticality] = policy_json
        app_short_name[criticality] = policy_json["properties"]["parameters"]["tagValue"]["defaultValue"]

    # Logic to print additions and removals of aa-app-shortnames from policies for respective criticality.
    # Calculate additions
    additions = {}
    for key, value in app_short_name.items():
        combined_set = set(app_criticality_dict[key])
        value_set = set(value)
        additions[key] = list(combined_set - value_set)

    # Calculate removals
    removals = {}
    for key, value in app_short_name.items():
        combined_set = set(app_criticality_dict[key])
        value_set = set(value)
        removals[key] = list(value_set - combined_set)

    # Convert to JSON with indentation
    json_additions = json.dumps(additions, indent=4)
    json_removals = json.dumps(removals, indent=4)

    # Log Addition and Removals
    logger.info("Addition: \n %s", json_additions)
    logger.info("Removals: \n %s", json_removals)
    
    if any(additions.values()) or any(removals.values()):
        # Generating PR body with additions and removals
        pr_body = {}
        pr_body["additions"] = additions
        pr_body["removals"] = removals
        pr_body_string = f"```json\n{json.dumps(pr_body, indent=4)}\n```"
        close_pr(owner, repo_name, pr_title)
        delete_branch(owner, repo_name, target_branch)
        create_branch(source_branch, target_branch, owner, repo_name)
        update_files_branch(app_criticality_dict, target_branch, owner, repo_name, commit_comment, policy_base_path, criticality_levels)
        logger.info("Updated all ResourceGroup policies")
        policy_base_path = "azure/policies/tags/Modify auto tag Resources with aa-criticality tag - "
        update_files_branch(app_criticality_dict, target_branch, owner, repo_name, commit_comment, policy_base_path, criticality_levels)
        logger.info("Updated all Resource policies")
        raise_pr(source_branch, target_branch, owner, repo_name, pr_title, pr_body_string)

if __name__ == "__main__":
    git_repo = os.getenv('GIT_REPO')
    owner, repo_name = git_repo.split('/')
    client_id = os.getenv('APIGEE_CLIENT_ID')
    client_secret = os.getenv('APIGEE_CLIENT_SECRET')
    source_branch = "nonprod"
    target_branch = "chore/update-aa-criticality-policies"
    pr_title="chore: Auto Updating Policies for aa-criticality"
    commit_comment = "Updated latest list of app short names for the respective criticality in policy.json"

    bearer_token = get_bearer_token(client_id, client_secret)
    if bearer_token:
        # Raw application data from Archer stored in "applications" variable
        applications = query_applications(bearer_token)
        
        if applications:
            # Segregating the application based on criticality, and if its Active & In Development state and store it in "app_criticality_dict" variable
            app_criticality_dict = categorize_applications(applications)
            process_branch(app_criticality_dict, source_branch, target_branch, owner, repo_name, pr_title, commit_comment)