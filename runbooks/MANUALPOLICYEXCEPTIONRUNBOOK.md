# Manual Policy Exception Request (Azure Portal)

During emergencies or high severity events, teams may request an immediate exception. These exceptions are manually applied through the Azure portal to minimize processing times. However, since these changes are made outside of our GaaS-Policy_as_Code policy, we must be wary and take the necessary precautions to process these kinds of exceptions properly, this guide will explain said process.

***Prerequisites***
- Read and Write access to the GaaS-Policy_as_Code repo

## Tutorial

This section will walk you through the process of applying a policy exception through the Azure portal.

1. [Document the Problem Statement](#1-document-the-problem-statement)
2. [Identify the Target Policy](#2-identify-the-target-policy)
3. [Sync the Exception Changes](#3-edit-the-policy-assignment)
4. [Create the Corresponding Documentation](#4-create-the-corresponding-pull-request)

### 1. Document the Problem Statement

Before applying the policy exception, discuss the problem statement with the requesting team. We want to make sure there is enough justification to apply the exception and set a timeline with the team for the exception. Most of the time these exceptions are temporary and only block deployments. Once the resource is created, the exception can be removed. This information will be required for the associated documentation.

For these kinds of exceptions, we will not be expecting the 3rd party approvals (VP/Cyber Security/Tech Radar) for policies found on the [Azure Policy Exception Process](https://wiki.aa.com/bin/view/TnT%20Technology%20and%20Platform%20Support/TnT%20Technology%20and%20Platform%20Engineering%20%E2%80%93%20Governance%20as%20a%20Service%20(GaaS)/Cloud%20Governance%20Policies/Azure%20Policies/?srid=MRAw2vX1) wiki.

If the exception is for a Severity incident, justification is automatically given but the necessary information should still be documented. Skip to step 3 in [Create the Corresponding Documentation](#4-create-the-corresponding-pull-request) for more information on documentation.

### 2. Identify the Target Policy

All the policies that have been created in the GaaS-Policy_as_Code repo are deployed to the Azure environment and can be found in the Policy blade from the portal. Please reference the image below.

![Policy Blade](../.readme_resources/images/azure-portal-policy-blade.png)

It can also be found by searching 'Policy' in the search bar as seen below.

![](../.readme_resources/images/azure-portal-policy-search.png)

Once in the Policy blade, navigate to the 'Assignments' page under the 'Authoring' section. Use the search bar in this page to find the policy by the policy name or assignment id as shown below. You will see 3 versions of the policy, one for each environment. You will need to identify the environment in which the exception needs to be applied and modify the corresponding policy.

![](../.readme_resources/images/azure-portal-policy-assignments.png)

### 3. Edit the Policy Assignment

Click into the correct policy assignment and then hit the 'Edit Assignment' button in the upper right corner.

![](../.readme_resources/images/azure-portal-policy-edit-assignment.png)

In the 'Assign Policy' page, navigate into the 3-dot blue button on the 'Exclusions' line. Choose the Subscription and Resource Group that the exception is for. Ideally the exception should be scoped down to the resource level but some policies are applied at resource group level.

![](../.readme_resources/images/azure-portal-policy-assign-policy.png)

Once the resource/resource group has been selected, hit 'Save' and then 'Review + save' to apply the exception. After this, have the requesting team verify they are no longer experiencing the policy block. The exception can take up to 20-30 minutes to take effect.

### 4. Create the Corresponding Pull Request

Since changes made to policies through the Azure portal will not be reflected in the GaaS-Policy_as_Code repo, we must create a pull request to close the gap. This pull request will also serve as documentation for the exception.

1. Create a new feature branch and identify the corresponding policy assignment file that needs to be modified. In this example, we are targeting the 'VM Creation Not Allowed' policy in the Production environment so the 'assign.p.PRODUCTION-MG.json' needs to be updated for this policy.

![](../.readme_resources/images/azure-portal-policy-pull-request.png)\

2. Add the resource id to the 'notScopes' list and follow the correct array format to prevent lint errors. New exceptions are added to the bottom of the list.

![](../.readme_resources/images/azure-portal-pr-not-scopes.png)
3. Once the 'notScopes' list has been updated, create the PR and provide the details regarding justification and timelines. This information should be added as part of the description in the PR.

![](../.readme_resources/images/azure-portal-policy-pull-request-description.png)

4. The next steps for the exception pull request depend on the timeline of the exception. 
    - If the exception is needed for a few hours (less than a day), the pull request does not need to be merged but should be closed once the exception is no longer needed. The on call engineer will need to remove the exception through the Azure portal before closing the corresponding pull request. 
    - If the exception is needed for an extended amount of time (more than a day), the pull request will need to be properly merged into the repo as if it were a regular exception request. Please refer to the [Policy Exception Runbook](/runbooks/POLICYEXCEPTIONRUNBOOK.md) for more information on this process. The on-call will have to create a new PR to remove the exception from the repo once it is no longer needed.




