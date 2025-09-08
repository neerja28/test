# Python script to update respective aa-ciriticality policy.json and make it up to date with archer data.

## Local Development


### Prereqs

- Running directly:
    - Python 3.11+
    - Environment variables Archer and github App credentials
        - `GIT_REPO` (Format: Owner/RepoName)
        - `APIGEE_CLIENT_ID`
        - `APIGEE_CLIENT_SECRET`
        - `OK_BOT_APP_ID` (Do not set if setting `PAT_TOKEN`)
        - `OK_BOT_KEY` (Do not set if setting `PAT_TOKEN`)
        - `PAT_TOKEN` (Optional: Add your Github personal access token, Only for running it locally)
      
### Clone the repository

```shell
git clone <your-repository-url>
cd GaaS-Policy_as_Code
```

### Install the dependencies

```shell
pip install -r scripts/aa-criticality-auto-update-policies/requirements.txt
```

### Run python script

```shell
python -m scripts.aa-criticality-auto-update-policies.main_script
```

### Flow diagram for the automation

![alt text](aa-criticality-automation.svg)
