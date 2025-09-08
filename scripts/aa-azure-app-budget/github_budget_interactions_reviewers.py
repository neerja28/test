import logging
import os
import ast
from ..github_interactions import *


# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("github_budget_interactions_reviewers")  # Set logger name

if __name__ == "__main__":
    git_repo = os.getenv('GIT_REPO')
    owner, repo_name = git_repo.split('/')
    fin_reviewers = os.getenv('FIN_REVIEW', '').split(',')
    io_reviewers = os.getenv('IO_REVIEW', '').split(',')
    cto_reviewers = os.getenv('CTO_REVIEW', '').split(',')
    gaas_reviewers = os.getenv('GAAS_REVIEW', '').split(',')
    author = os.getenv('AUTHOR')
    pr_number = os.getenv('PR_NUMBER')
    comment = os.getenv('COMMENT')

    # Convert the string representation of the list back to an actual list
    # reviewers_users = ast.literal_eval(reviewers)
    # reviewers_nofin_user = ast.literal_eval(reviewers_nofin)
    logger.info("All the gaas reviewers #%s", gaas_reviewers)
    g_reviewers = [reviewer.strip().strip("'") for reviewer in gaas_reviewers]
    c_reviewers = [reviewer.strip().strip("'") for reviewer in cto_reviewers]
    i_reviewers = [reviewer.strip().strip("'") for reviewer in io_reviewers]
    f_reviewers = [reviewer.strip().strip("'") for reviewer in fin_reviewers]

    logger.info("list of reviewers #%s", g_reviewers)
    logger.info("PR #%s", pr_number)

    # comment_values = ['lgtm','approve', 'approved', 'accepted']
    # # Only proceed if comment is 'lgtm' or any of the other specified words
    # if comment in comment_values:
    #     update_reviewers_onbody(owner, repo_name,pr_number,f_reviewers,i_reviewers,c_reviewers,g_reviewers,author)

