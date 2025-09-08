# On-Call Runbook: Onboarding Request Application

## Overview
The Onboarding Request application simplifies the approval process, enabling application teams to create resources in the cloud efficiently.

## Key Features
- **Create Onboarding Requests via [Runway](https://developer.aa.com/)**
  - Application teams use the `appshortname` and follow steps outlined in the [onboarding request process](https://developer.aa.com/create/templates/default/gaas-app-onboard).
  - The `template.yaml` file serves as input to the Runway steps for creating pull requests.
  - A pull request is created in the [**GaaS PolicyasCode Repo**](https://github.com/AAInternal/GaaS-Policy_as_Code) with the pattern:
    - `feat: onboard new app to Azure*`
    ![newrequest](../.readme_resources/images/newonboardreq.png)
- **GitHub Workflow Triggers**
  - GitHub workflows create approval labels.
  - Python scripts make **Apptio budget approval process API calls**.
  - Approval labels are updated based on feedback from Financial, CTO/EA, and IO/FinOps teams. Approvers must comment "approve" on the pull request to proceed.
- **Approver Identification**
  - Approvers are GitHub users part of the approval group and are exclusively authorized to approve pull requests.

---

## Getting Started
The Onboarding application includes GitHub workflows that trigger Python scripts. Pull requests created via Runway generate a JSON entry in the **GaaS Policy-as-Code repository**, using the `appshortname` as the key to initiate policy creation for new applications and updates.

### Prerequisites
- **Python 3.8** or higher
- **Visual Studio Code** for development
- Required libraries ([`requirements.txt`](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/scripts/requirements.txt))
- GitHub [workflows](https://github.com/AAInternal/GaaS-Policy_as_Code/tree/main/.github/workflows) and secrets, including a **GH PAT token** for testing
- Sample onboarding [pull request](https://github.com/AAInternal/GaaS-Policy_as_Code/pull/2188)
- JSON policy files ([`policy.json`](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/tags/EnforceAAAppShortName/policy.json))
- Clone the repository: **GaaS PolicyasCode Repo**
- [`template.yaml`](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/template.yaml) file

---

## How the Onboarding Application Works
1. **Configuration File**: The `template.yaml` file provides input for the Runway template to create a pull request.
   - Guides teams to provide:
     - `appshortname`
     - Vertical
     - Budget requirements
     - Architecture approval docs
   - Checks if the `appshortname` already exists in **GaaS PolicyasCode**. If so:
     - Users are notified: "No pull request will be created."
   - If it's a new application:
     - A pull request is created.
     - The policy file is updated in the GaaS repo. Refer to the `policy.json` file in the Prequiste section.

2. **Pull Request and Workflow**:
   - The pull request triggers a GitHub workflow.
   - Workflow processes:
     - Extracts key information (e.g., `appshortname`, PR title, budget info).
     - Automates the budget approval process. Refer to GitHub [Budget Approval Process](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/.github/workflows/az-app-onboard-budget-approval-process.yml)

3. **Approval Process**:
   - Approval labels are based on comments from Financial, CTO/EA, and IO/FinOps teams.
   - When all labels turn green, the pull request is approved. Refer to [Comment Based Approval Process](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/.github/workflows/az-app-onboard-comment.yml)

4. **Final Steps**:
   - The **AzAppOnboard** label is updated.
   - The GaaS team approves and merges the pull request.

### `template.yaml` Configuration
```yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: gaas-app-onboard
  title: Onboard New App to Azure
  description: Request approval to onboard app to Azure. Ensure you have confirmation from your financial analyst that you have cloud budget for this app, and provide the URLs to your architecture artifacts.
spec:
  owner: TnT-Squad-007
  type: service

  parameters: cmdbAppShortName, vertical, budgetEstimate, architectureArtifactsLink, justification
  steps: checkAppshortname, append-resources, log-onboarding-message, publish
  output: url
```
## PR Requests and Merge Requirements

Here is an example of a merge request in action. All onboarding PR requests are created for the **Main** branch: [Sample PR](https://github.com/AAInternal/GaaS-Policy_as_Code/pull/2205).

1. **Approval Process**:
   - An approval was made from the **EA team** by adding a comment as **“approve”**, which turned the **CTO/EAs** label green ✅.
   - An approval was made from the **Finance team** by adding a comment as **“approve”**, which turned the **Finance** label green ✅.
   - Refer to the **Comment-Based Approval Process** in the section *How the Onboarding Application Works* to understand how the **AzAppOnboard** label turns green ✅ based on the above steps.
   ![approved-request](../.readme_resources/images/onboardrequest2.png)

2. **Merging Requests**:
   - Once all labels are green, the PR is ready for merging.

3. **Engineer Responsibilities**:
   - Verify that all other workflows have been conducted and cleared with no issues.
   ![merge requirements](../.readme_resources/images/onboardingrequest1.png)

4. **Branch Update**:
   - Update the branch if required and proceed to the next step.

5. **Trigger Manual Task**:
   - There is a task to manually trigger for **apply-dev-fork**. This will display as **Expected — Waiting for status to be reported**.
     - Use the following command to trigger:  
       `/ok-to-apply-dev sha=<last_commit_sha>` (replace `<last_commit_sha>` with the last commit SHA ID from the PR request, e.g., `6ee2080`).
     - Ensure the workflow is completed without any issues.

6. **Final Merge**:
   - Once all workflows for the merge are completed, the PR is ready to be merged.
   - A peer review is required to accept the PR into the **Main** branch.

7. **Sync to Non-Prod**:
   - The final step is to sync from **Main** to **Non-Prod**.
   - Example: [Sync PR](https://github.com/AAInternal/GaaS-Policy_as_Code/pull/2209).
   - Ensure the PR title matches the pattern: `sync: main => nonprod`.
   - Follow steps 3–6 above to complete the sync process.


## Troubleshooting and Tips

### Slack Integration
All pull requests are integrated with Slack via the onboarding bot, using a Slack webhook and GitHub workflow. Refer to the channel `#io-gaas-policy-as-code-prs`

### Action for Stalled Requests
Review pull requests open for over a week. Prompt submitters for follow-up as needed. [All Opened Onboarding PR View](https://github.com/AAInternal/GaaS-Policy_as_Code/pulls?q=is%3Apr+is%3Aopen+feat%3A+onboard+new+app+to+Azure+in%3Atitle)

---

## Disaster Recovery  
**If Runway is down:**

1. Gather the `appshortname`.
2. Fork the **GaaS PolicyasCode Repo** and manually update [`policy.json`](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/tags/EnforceAAAppShortName/policy.json) with the `appshortname`.
3. Create a pull request with:
   - **Title**: `feat: onboard new app to Azure - <appshortname>`
   - **Comments**:
     ```markdown
     - App Short Name: <appshortname>
     - App VP: <VP of the vertical>
     - Cloud Budget for the App: <Yes|No>
     - Annual Cloud Budget: <amount>
     - Architecture Artifacts Link: <link>
     - Business Justification: <justification>
     - Submitted By: <@github_user>
     - Submitted Date in GMT: <MM/DD/YYYY HH:MM:SS>
     - Approver:
        @AAInternal/cloud-finance-approvers
        @AAInternal/cloud-architecture-approvers
     - Notified:
        @AAInternal/cloud-finops-onboarding-notification
     - For questions regarding process review [New App Onboard Azure - Approval Process](https://wiki.aa.com/bin/view/TnT%20Technology%20and%20Platform%20Support/TnT%20Technology%20and%20Platform%20Engineering%20%E2%80%93%20Governance%20as%20a%20Service%20%28GaaS%29/Accountability%20of%20application%20cloud%20cost%20and%20architecture/Accountability%20of%20application%20cloud%20cost%20and%20architecture/)

     ```

---

## Architecture

### Key Components
- **Runway Developer Platform**: Uses Backstage plugins for onboarding.
- **GitHub Workflows and Python Scripts**: Processes requests and triggers approvals.
- **Apigee Credentials**: For Apptio Budget API calls.

---

## References
- **New application onboarding request process wiki** - [wiki](https://wiki.aa.com/bin/view/TnT%20Technology%20and%20Platform%20Support/TnT%20Technology%20and%20Platform%20Engineering%20%E2%80%93%20Governance%20as%20a%20Service%20(GaaS)/Accountability%20of%20application%20cloud%20cost%20and%20architecture/Accountability%20of%20application%20cloud%20cost%20and%20architecture/?srid=4qvVJYQL)
- **Runway Implementation**: [Backstage plugins](https://github.com/AAInternal/runway)
- **Apigee Documentation**:
  - [Apigee Dev](https://aa-dev-passenger.apigee.io/)
  - [Apigee Prod](https://aa-prod-passenger.apigee.io/)
  

---

## Contact
For support, contact the **GaaS Team** at [DL_GaaS@aa.com](mailto:DL_GaaS@aa.com).

