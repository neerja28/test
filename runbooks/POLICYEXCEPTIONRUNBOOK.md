# New Policy Exception Request

Policy exceptions are granted to teams for a variety of reasons and are usually created by the app team requesting the exception. All policy exceptions should be done through this repository, GaaS-Policy_as_Code. New policy exception requests will always start with the 'ex: ' prefix.

***Prerequisites***
- Read and Write access to the GaaS-Policy_as_Code repo
- VS Code or similar
- Gitbash or similar

## Tutorial

This section will walk you through the process of merging a pull request for a policy exception.

1. [Verify the file being modified and target branch](#1-verify-the-file-being-modified-and-target-branch-match)
2. [Identify the Target Policy](#2-identify-the-target-policy)
3. [Merging the Exception Pull Request](#3-merging-the-exception-pull-request)
4. [Sync the Exception Changes](#4-sync-the-exception-changes)

### 1. Verify the File Being Modified and Target Branch Match

The file being modified and the target branch should match. If an exception for a NONPROD policy file is being requested, the target branch should be 'nonprod'. This will prevent confusion and allow the request to handled more efficiently. 

![](../.readme_resources/images/exception-pr-example.png)

If both NONPROD and PROD files are being modified, please follow the regular flow of merging into the 'nonprod' branch first and then into the 'main' branch.

[Branch Flow](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/README.md#branching)

### 2. Identify the Target Policy

The way a policy exception is handled depends on the policy the exception is for. There are specific policies that require additional review outside of the GaaS team. These policies can be found on the wiki page below.

[Azure Policy Exception Process](https://wiki.aa.com/bin/view/TnT%20Technology%20and%20Platform%20Support/TnT%20Technology%20and%20Platform%20Engineering%20%E2%80%93%20Governance%20as%20a%20Service%20(GaaS)/Cloud%20Governance%20Policies/Azure%20Policies/?srid=MRAw2vX1)

For example, the following PR is for the policy blocking new Virtual Machine deployments, 'VM Creation Not Allowed':

[ex: Add SAIS RGs to exclusion list of VM Creation not allowed](https://github.com/AAInternal/GaaS-Policy_as_Code/pull/2105)

This exception request corresponds to bullet #4 'VM Creation not allowed' on the wiki page and requires the approval of the requesting team's respective VP. This approval is usually granted through email or IM and should then be added to the PR for documentation as seen below.

![](../.readme_resources/images/Vm-approval-example.png)

The GaaS team is NOT responsible for acquiring the necessary approvals on behalf of the requesting team.

If the policy is not on the list in the Azure Policy Exception Process wiki, then it does not require additional approvals outside the GaaS team and is ready to be worked on. We ask that teams provide their reasoning/need and timelines for the exception in the description of the PR. 

It is the duty of the GaaS team to follow up on the temporary exceptions based on the requested time window.

### 3. Merging the Exception Pull Request

Once any additional approvals/reviews are done and documented in the PR, it is ready to be merged. Since most of these requests will be coming from forks rather than a direct branch on the GaaS-Policy_as_Code repo, the steps to close these PRs are slightly different.

1. Make sure the PR is up to date with both the 'nonprod' and 'main' branches.
   The most recent commits on those two branches should be pulled into the PR. This can be done through Github, Gitbash, VS Code terminal, etc.
2. Forks will cause failures/skips in the Terraform Plan status checks. These checks will need to be  
   triggered manually. The following commands should be used to trigger the PR checks by commenting them on the PR.

   - Terraform Plan Dev => /ok-to-plan-dev sha=#######
   - Terraform Plan Non Prod => /ok-to-plan-nonprod sha=#######
   - Terraform Plan Prod => /ok-to-plan-prod sha=#######

   The empty values after 'sha' are the last 7 characters of the most recent commit on the PR. Please reference the image below.
   
   ![](../.readme_resources/images/terraform-plan-example.png)
   
   The commit provided will be used to for the Terraform Plans so please make sure the PR is up to date. Once the plans have passed, please review the logs to make sure the planned changes are associated to the exception.

   Once the plans have been reviewed and all the checks have passed the PR can be approved and merged.

### 4. Sync the Exception Changes

The GaaS-Policy_as_Code repo manages policies by environment and both environments have their respective branch: the 'nonprod' branch for the Non Production environment and the 'main' branch for the Production environment. These branches need to stay in sync in order to maintain integrity within the environments.

After an exception has been merged into either the 'nonprod' or 'main' branch, a follow up 'sync' PR should be created to merge the changes from one branch to the other. The sync PR should use the 'sync:' prefix and should be titled based on which branch will be the base branch. Please reference the examples below.

  ![](../.readme_resources/images/sync-pr-example-1.png)

  ![](../.readme_resources/images/sync-pr-example-2.png)

The changes for the exception PR and the changes for the sync PR should match. This should be verified before merging the sync PR to prevent unwanted changes.

Since this has to be done by a GaaS member, it will require a second team member to approve and merge.

Once the sync is merged, Congratulations! The exception has been successfully processed and completed.

***ALWAYS DOUBLE CHECK THE BASE BRANCH BEFORE SUBMITTING THE SYNC PULL REQUEST***

### FAQs

***How long is the turnaround time for exceptions?***

Most of our users are familiar with the exception process and will come prepared with the necessary approvals. Most exceptions are processed within a few hours but none have taken longer than a couple of days.

***A user has asked me (GaaS team member) to create the exception PR for them. How is this handled?***

We highly discourage this and recommend that the end user create the PR from their end. This helps in tracking and documenting the exception back to the requesting team rather than back to GaaS. By having the team member create the PR, only one GaaS member will be needed to process it. If the PR is created by a GaaS member, a second member will need to approve and help process the PR.

***Can I add an exception to a policy through the Azure Portal?***

Technically, yes. Any policy changes made through will not be reflected in the GaaS-Policy_as_Code repo and risk being overwritten when the next deployment from the repo is made. In emergency cases where the need for an exception is immedaite, the changes made through the portal should also be made in the GaaS-Policy_as_Code repo to maintain integrity with the respective environment.

If there is a severity event or a team needs an immediate exception with sufficient justification, please follow the reference below for guidance on adding the exception manually through the Azure portal.
