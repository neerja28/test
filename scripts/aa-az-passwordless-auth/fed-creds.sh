#!/bin/sh

REPO="GaaS-Policy_as_Code"
ORG="AAInternal"
SPID="286a8529-7388-42a2-9983-d7e74390c73a" # Set the Client ID of nonprod and prod SP dt-p-CldGovAuto-policyeditor-3145-sp
DEFAULT_BRANCH="main"
NONPROD_BRANCH="nonprod"

# Login to Azure
az login

# Create Fed cred for Pull Request 
az ad app federated-credential create \
--id $SPID \
--parameters "{\"name\":\"github_pull_request\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${ORG}/${REPO}:pull_request\",\"description\":\"github_pull_request\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

# Create Fed cred for nonprod branch
az ad app federated-credential create \
--id $SPID \
--parameters "{\"name\":\"github_branch_${NONPROD_BRANCH}\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${ORG}/${REPO}:ref:refs/heads/${NONPROD_BRANCH}\",\"description\":\"github_branch_${NONPROD_BRANCH}\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

# Create Fed cred for Main branch
az ad app federated-credential create \
--id $SPID \
--parameters "{\"name\":\"github_branch_${DEFAULT_BRANCH}\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${ORG}/${REPO}:ref:refs/heads/${DEFAULT_BRANCH}\",\"description\":\"github_branch_${DEFAULT_BRANCH}\",\"audiences\":[\"api://AzureADTokenExchange\"]}"
