import os
import json
import base64
from github import Github, GithubIntegration
from github.GithubException import UnknownObjectException
import logging
import subprocess

# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("github_interactions")  # Set logger name

# Function to generate token using app_id and app_key
def generate_token(owner, repo_name):
    id = os.getenv('OK_BOT_APP_ID')
    private_key = os.getenv('OK_BOT_KEY')
    app = GithubIntegration(id, private_key)
    token = app.get_access_token(
        app.get_installation(owner, repo_name).id
    ).token
    return token

# Functions to interact with GitHub. Functions imported from update app short name workflow
def get_repos(owner, repo_name):
    try:
        token = os.getenv('PAT_TOKEN')
        if token is None:
            token = generate_token(owner, repo_name)
        g = Github(login_or_token=token)
        repo = g.get_repo("{}/{}".format(owner, repo_name))
    except Exception as e:
        logger.error("Error occurred while getting repo object: {}".format(e))
        raise e
    return repo

def get_child_branch(owner, repo_name, pr_title):
    try:
        repo = get_repos(owner, repo_name)
        pulls = repo.get_pulls()
        branch_name = ""
        for p in pulls:
            if p.title == pr_title:
                branch_name = p.head.ref
        logger.info("Branch Name: %s", branch_name)
        return branch_name
    except Exception as e:
        logger.error("Error while getting child branch: {}".format(e))
        raise e

def delete_branch(owner, repo_name, target_branch):
    try:
        branch_name = ""
        repo = get_repos(owner, repo_name)
        for i in list(repo.get_branches()):
            if i.name.startswith(target_branch):
                branch_name = i.name
                ref = repo.get_git_ref(f"heads/{branch_name}")
                ref.delete()
                logger.info("Deleted branch: %s", branch_name)
    except UnknownObjectException:
        logger.warning("No such branch: %s", branch_name)

def create_branch(source_branch, target_branch, owner, repo_name):
    try:
        repo = get_repos(owner, repo_name)
        sb = repo.get_branch(source_branch)
        repo.create_git_ref(ref='refs/heads/' + target_branch, sha=sb.commit.sha)
        logger.info("Created branch: %s", target_branch)
    except Exception as e:
        logger.error("Error while creating branch: {}".format(e))
        raise e

def close_pr(owner, repo_name, pr_title):
    try:
        repo = get_repos(owner, repo_name)
        pulls = repo.get_pulls()
        for p in pulls:
            if p.title == pr_title:
                p.edit(state='closed')
                logger.info("PR was closed at: %s", p.closed_at)
    except Exception as e:
        logger.error("Error while closing PR: {}".format(e))
        raise e

def update_policy_file(owner, repo_name, policy_path, policy_file, target_branch, commit_comment):
    try:
        repo = get_repos(owner, repo_name)
        contents = repo.get_contents(policy_path, ref=target_branch)
        json_str = json.dumps(policy_file, indent=2)
        repo.update_file(policy_path, commit_comment, json_str, contents.sha, branch=target_branch)
        logger.info("File updated: %s", policy_path)
    except Exception as e:
        logger.error("Error while updating file: {}".format(e))
        raise e

def raise_pr(source_branch, target_branch, owner, repo_name, pr_title, pr_body):
    try:
        repo = get_repos(owner, repo_name)
        body = pr_body
        pr = repo.create_pull(title=pr_title, body=body, head=target_branch, base=source_branch)
        logger.info("PR Raised: %s", pr.id)
        logger.info("PR number: %s", pr.number)
    except Exception as e:
        logger.error("Error while raising PR: {}".format(e))
        raise e
    return pr.number

def get_git_policy_json(owner, repo_name, policy_path, branch_name="main"):
    try:
        repo = get_repos(owner, repo_name)
        contents = repo.get_contents(policy_path, ref=branch_name)
        content_bytes = base64.b64decode(contents.content)
        content_str = content_bytes.decode('utf-8')
        policy_json = json.loads(content_str)

    except Exception as e:
        logger.error("Error occurred while getting app short name list from GitHub policy JSON: {}".format(e))
        raise e
    return policy_json

def update_onboarding_branch(owner, repo_name, is_approved_budget, pr_title, appshort_name, review_nofin, app_budget, approved_budget_amt):
    try:
        draft_pr = get_onboarding_draft_pr(owner, repo_name, pr_title)
        logger.info("Budget is approved? #%s",  is_approved_budget)
        if(is_approved_budget == 'True'):
            #update the branch comment
            # Check if the pull request is in draft mode
            # if draft_pr.draft:                
                # mark_pr_ready_for_review(owner, repo_name, draft_pr.number)
                comment_body = "The requested funding is automatically approved as it falls within the Cloud Budget for {}.\n Requested Amount: ${}\n Annual Budget in Apptio: ${}".format(appshort_name,app_budget,approved_budget_amt)
                draft_pr.create_issue_comment(comment_body)
                # add reviewers
                # update_team_reviewers(owner, repo_name, draft_pr.number, reviewers)
                # update_team_reviewers(owner, repo_name, draft_pr.number, codeowners)

                #add labels
                labelToAdd = 'Finance :white_check_mark:';
                labelToRemove = 'Finance :clock230:';
                #remove finance
                update_labels_body(draft_pr,labelToAdd, labelToRemove, review_nofin)


        else:
            logger.info("Pull request is not ready for review for PR #%s", draft_pr.number)
            comment_body = "The requested budget doesn't fall within the cloud budget or Monthly BudgetFile is not updated in Finops for {}.\n Requested Amount: ${}\n Annual Budget in Apptio: ${}".format(appshort_name,app_budget,approved_budget_amt)
            draft_pr.create_issue_comment(comment_body)


    except Exception as e:
        logger.error("Error occured while updating the onboarding branch: {}".format(e))
        raise e

def get_onboarding_draft_pr(owner, repo_name, pr_title):
    repo = get_repos(owner, repo_name) 
    pulls = repo.get_pulls(state='open', sort='created', direction='desc')

    draft_pr = None
    for pr in pulls:
        if pr_title in pr.title:
            draft_pr = pr
            break

    # Output the result
    if draft_pr:
        logger.info("Draft pull request found:  #%s - #%s", draft_pr.number, draft_pr.title )

    else:
        print("No draft pull request found for the specified branch.")

    return draft_pr


def update_labels_body(pr, labelToAdd, labelToRemove, groupToUnnotify):
        logger.info("calling update body for #%s", groupToUnnotify)
        pr.add_to_labels(labelToAdd)
        pr.remove_from_labels(labelToRemove)
        # Retrieve the current PR body
        current_body = pr.body
        updated_body = current_body.replace(groupToUnnotify, '')
        pr.edit(body=updated_body)
        logger.info("PR is updated with body #%s removed", groupToUnnotify)

# Function to delete a file
def delete_file(owner, repo_name, file_path, target_branch, commit_comment):
    try:
        repo = get_repos(owner, repo_name)
        contents = repo.get_contents(file_path, ref=target_branch)
        repo.delete_file(file_path, commit_comment, contents.sha, branch=target_branch)
        logger.info("File deleted: %s", file_path)
    except Exception as e:
        logger.error("Error while deleting file: {}".format(e))
        raise e

# Function to create a file
def create_file(owner, repo_name, file_path, file_content, target_branch, commit_comment):
    try:
        repo = get_repos(owner, repo_name)
        repo.create_file(file_path, commit_comment, file_content, branch=target_branch)
        logger.info("File created: %s", file_path)
    except Exception as e:
        logger.error("Error while creating file at %s: %s", file_path, str(e))
        raise

# Function to comment on PR
def comment_on_pr(owner, repo_name, pr_number, comment_body):
    try:
        repo = get_repos(owner, repo_name)
        pr = repo.get_pull(pr_number)
        pr.create_issue_comment(comment_body)
        logger.info("Commented on PR #%s: %s", pr_number, comment_body)
    except Exception as e:
        logger.error("Error while commenting on PR: {}".format(e))
        raise e
    
# Function to check if a file exists
def file_exists(owner, repo_name, file_path, branch_name="main"):
    try:
        repo = get_repos(owner, repo_name)
        repo.get_contents(file_path, ref=branch_name)
        logger.info("File exists: %s", file_path)
        return True
    except UnknownObjectException:
        logger.info("File does not exist: %s", file_path)
        return False
    except Exception as e:
        logger.error("Error while checking if file exists: {}".format(e))
        raise e
