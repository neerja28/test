import os
from ..github_interactions import *
from .apptio_budget import *
import logging

# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("aa-azure-budget")  # Set logger name


def check_budget_approval(budget: float, approved_amount: float):

    is_approved = False

    if approved_amount <= 0:
        is_approved = False
    if approved_amount > 0:
        if approved_amount >= budget:
            is_approved = True
    
    return is_approved

        # if budgetResponse:
        #     print(budgetResponse)

def get_budget_from_json(budgetResponse):

    json_string = json.dumps(budgetResponse)
    data = json.loads(json_string)

    # Access the float value
    approved_budget = data.get("annual_azure_budget", 0.0)

    print(f"Total approved_budget: {approved_budget:.2f}")

    return approved_budget



if __name__ == "__main__":
    git_repo = os.getenv('GIT_REPO')
    owner, repo_name = git_repo.split('/')
    client_id = os.getenv('APIGEE_CLIENT_ID')
    client_secret = os.getenv('APIGEE_CLIENT_SECRET')
    app_shortname = os.getenv('APP_SHORT_NAME')
    app_budget = float(os.getenv('APP_BUDGET', "0.0"))
    is_approved = False
    
    bearer_token = get_bearer_token(client_id, client_secret)
    if bearer_token:
        budgetResponse = get_budget_api(bearer_token, app_shortname)
        if budgetResponse:
            print(budgetResponse)
        approved_amount = get_budget_from_json(budgetResponse)
        is_approved = check_budget_approval(app_budget, float(approved_amount))
        print(f"Budget Approved: {is_approved}")

    
    # Set the output for GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f'APPROVED_BUDGET={is_approved}\n')

    # Set the output for GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f'APPROVED_AMT={approved_amount}\n')



