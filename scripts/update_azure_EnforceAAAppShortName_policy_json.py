import asyncio
import logging
from github import Github, GithubIntegration
import json
import requests
from github.GithubException import UnknownObjectException
import config as config
from datetime import date
from archer_records.archer import ArcherRecords
logger = logging.getLogger("shortnames")
import sys

today = date.today()
d3 = today.strftime("%m/%d/%y")
print(d3)
dyn_branch_name = "chore/aa-app-shortname-list-"+d3
print(dyn_branch_name)


def get_repos():
    try:
        # Get the App
        id = int(config.app_id)
        private_key = config.app_key
        app = GithubIntegration(id, private_key)
        owner = "AAInternal"
        repo_name = "GaaS-Policy_as_Code"
        g = Github(
        login_or_token=app.get_access_token(
            app.get_installation(owner, repo_name).id
        ).token
    )
        repo = g.get_repo("AAInternal/GaaS-Policy_as_Code")
    except Exception as e:
            logger.error("Error occured while getting repo object: {}".format(e))
            raise e
    return repo

# Returns List with ShortNames from archer 
def get_shtnm_vals_archer(applications_meta):
        try:
            logger = logging.getLogger("shortnames")
            valid_shtnms = []
            for app in applications_meta:
                valid_shtnms.append(app["shortName"])
        except Exception as e:
            logger.error("Error occured while getting valid shortnames from archer: {}".format(e))
            raise e
        return valid_shtnms

# Returns List with ShortNames from git Policy Json
def get_shtnm_vals_git_policy_json(branch_name = "main"):
        try:
            repo = get_repos()
            contents = repo.get_contents("azure/policies/tags/EnforceAAAppShortName", ref=branch_name)
            for content_file in contents:
                policy_json_url = content_file.download_url
            resp = requests.get(policy_json_url)
            policy_json = json.loads(resp.text)
            valid_shtnms = policy_json["properties"]["parameters"]["tagValue"]["defaultValue"]
        except Exception as e:
            logger.error("Error occured while while getting valid shortnames from git policy json: {}".format(e))
            raise e
        return policy_json, valid_shtnms

def get_child_branch():
    try:
        repo = get_repos()
        pulls = repo.get_pulls()
        branch_name = ""
        for p in pulls:
            if p.title == "chore: Auto PR App Shortname list update":
                branch_name = p.head.ref
        print(branch_name)
        return branch_name
    except Exception as e:
            logger.error("Error while closing pr: {}".format(e))
            raise e

def delete_branch():
    try:
        branches = []
        branch_name = ""
        repo = get_repos()
        for i in list(repo.get_branches()):
            if (i.name).startswith("chore/aa-app-shortname"):
                branch_name = i.name
            branches.append(i.name)
        if branch_name.startswith("chore/aa-app-shortname"):
            ref = repo.get_git_ref(f"heads/{branch_name}")
            ref.delete()
            print("deleted chore/aa-app-shortname-list branch")
    except UnknownObjectException:
        print('No such branch', branch_name)

def create_branch(source_branch, target_branch):
    try:
       repo = get_repos()
       sb = repo.get_branch(source_branch)
       repo.create_git_ref(ref='refs/heads/' + target_branch, sha=sb.commit.sha)
       print("created chore/aa-app-shortname-list branch")
    except Exception as e:
        logger.error("Error while creating branch: {}".format(e))
        raise e

def close_pr():
    try:
        repo = get_repos()
        pulls = repo.get_pulls()
        for p in pulls:
            if p.title == "chore: Auto PR App Shortname list update":
                p.edit(state='closed')
                print('PR was closed at: ', p.closed_at)
    except Exception as e:
            logger.error("Error while closing pr: {}".format(e))
            raise e

def update_file_branch(policy_json_str):
    try:
        data = json.dumps(policy_json_str,indent=2)
        repo = get_repos()
        contents = repo.get_contents("azure/policies/tags/EnforceAAAppShortName/policy.json", ref=dyn_branch_name)
        # update
        repo.update_file("azure/policies/tags/EnforceAAAppShortName/policy.json", "updated latest shortname list to Policy Json",data, contents.sha, branch= dyn_branch_name)
        print("updated policy.json file with latest shortnames list")
    except Exception as e:
            logger.error("Error while updating file: {}".format(e))
            raise e

def raise_pr():
    try:
        repo = get_repos()
        body = '''
        Automated PR to Update Shortnames list in Policy JSON File
        '''
        pr = repo.create_pull(title="chore: Auto PR App Shortname list update", body=body, head=dyn_branch_name, base="main")
        print("PR Raised :",pr.id)
    except Exception as e:
            logger.error("Error while raising pr: {}".format(e))
            raise e





async def main():
     
    source_branch = 'main'
    target_branch = dyn_branch_name
    ARCHER_USER_ID = config.archer_user
    ARCHER_PASSWORD = config.archer_pwd
    a = ArcherRecords(ARCHER_USER_ID,ARCHER_PASSWORD)
    archer_list = []
    try:
        AReportID = "4878B0EC-8FB5-4FC3-8EEC-B3663A2E27A0"
        df = a.get_archer_records(AReportID)
        status = ['Active (production)', 'In Development (pre-production)']
        df = df[df['status'].isin(status)]
        archer_list = df["application_short_name"]
    except Exception as e:
         print(e)
         print("ArcherSDK Faild, Please Check")
         sys.exit(1)
    logger.info("Lenght of archer list:",len(archer_list))
    policy_json, policy_json_list = get_shtnm_vals_git_policy_json()  
    diff = set(archer_list) - set(policy_json_list)
    diff_list = list(diff)
    #exit()
    if len(diff_list) == 0:
        print("Policy.json shortnames list is up to date with archer shortname list")
    else:
        branch_name = get_child_branch()
        if branch_name.startswith("chore/aa-app-shortname"):
            child_policy_json, child_policy_json_list = get_shtnm_vals_git_policy_json(branch_name)  
            child_diff = set(archer_list) - set(child_policy_json_list)
            child_diff_list = list(child_diff)
            if len(child_diff_list) == 0:
                print("Policy.json shortnames list is up to date with archer shortname list in child branch")
                exit()
            else:
                print("New App ShortNames from Archer")
                print(child_diff_list)
        try:
            close_pr()
            policy_json_list.extend(diff_list)
            policy_json_list = list(filter(lambda item: item is not None, policy_json_list))
            policy_json_list = [i for i in policy_json_list if i]
            policy_json_list.sort(key=str.casefold)
            policy_json["properties"]["parameters"]["tagValue"]["defaultValue"] = policy_json_list
            delete_branch()
            create_branch(source_branch, target_branch)
            update_file_branch(policy_json)
            raise_pr()
        except Exception as e:
            print(e)
            print("Error with GitHub")
            sys.exit(1)


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
