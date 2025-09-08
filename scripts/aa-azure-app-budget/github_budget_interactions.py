import logging
import os
import ast
from ..github_interactions import *


# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("app_budget_github_interactions")  # Set logger name


if __name__ == "__main__":
    git_repo = os.getenv('GIT_REPO')
    owner, repo_name = git_repo.split('/')
    is_approved_budget = os.getenv('IS_APPROVED_BUDGET')
    pr_title = os.getenv('PR_TITLE')
    appshort_name = os.getenv('APP_SHORT_NAME')
    reviewers_nofin =  os.getenv('REVIEWERS_NOFIN')
    app_budget = os.getenv('APP_BUDGET')
    approved_budget_amt = os.getenv('APPROVED_AMT')

    update_onboarding_branch(owner, repo_name, is_approved_budget, pr_title, appshort_name, reviewers_nofin, app_budget, approved_budget_amt)
