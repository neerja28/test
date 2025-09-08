# Python script to update shortname lists in policy.json to make up to date with archer

## Local Development


### Prereqs

- Running directly:
    - Python 3.7+
    - Environment variables Archer and github App credentials
        - `ARCHER_USER`
        - `ARCHER_PWD`
        - `OK_BOT_APP_ID`
        - `OK_BOT_KEY`
      
### Navigate to scripts folder

 ``` cd GaaS-Policy_as_Code/scripts ```

### Install the dependencies

``` pip install -r requirements.txt ```

### Run python script

``` python update_azure_EnforceAAAppShortName_policy_json.py ```
