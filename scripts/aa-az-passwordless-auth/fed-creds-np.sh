#!/bin/sh

# App Registration (OIDC) parameters

REPO="GaaS-Policy_as_Code"
ORG="AAInternal"
SPID="493b3411-4d57-4d74-8408-4bf2db8d5da8" # Set the Client ID dev SP 
NONPROD_BRANCH="nonprod"
DEFAULT_BRANCH="main"

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

# Create Fed cred for main branch
az ad app federated-credential create \
--id $SPID \
--parameters "{\"name\":\"github_branch_${DEFAULT_BRANCH}\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${ORG}/${REPO}:ref:refs/heads/${DEFAULT_BRANCH}\",\"description\":\"github_branch_${DEFAULT_BRANCH}\",\"audiences\":[\"api://AzureADTokenExchange\"]}"
