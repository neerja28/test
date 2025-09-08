# Running the Code Locally

## Requirements
- Python 3.11 and above

## Setup Instructions

1. **Clone the Repository**
    ```sh
    git clone https://github.com/AAInternal/GaaS-Policy_as_Code.git
    ```

2. **Install the Requirements**
    ```sh
    pip install -r ./GaaS-Policy_as_Code/scripts/get-subscription-owner-details/requirements.txt
    ```

3. **Azure CLI Setup**
    - Make sure you have Azure CLI installed.
    - Login to Azure CLI to allow the script to use your credentials:
        ```sh
        az login
        ```
    - Alternatively, set following environment variables from your Service Principal (SPN):
        ```sh
        export AZURE_CLIENT_ID=<Client-ID>
        export AZURE_TENANT_ID=<Tenant-ID>
        export AZURE_CLIENT_SECRET=<Client-Secret>
        ```
    

## Input Files

### exception.json

The `exception.json` file contains a list of subscriptions that should be excluded from the "more than 3 owners" warning. The schema is as follows:

```json
{
    "exceptions": [
        {
            "subscription_id": "<subscription-id>",
            "subscription_name": "<subscription-name>",
            "expiration_date": "yyyy-mm-dd"
        },
        {
            "subscription_id": "<subscription-id>",
            "subscription_name": "<subscription-name>",
            "expiration_date": "yyyy-mm-dd"
        }
    ]
}
```
- subscription_id: The ID of the subscription to be excluded.
- subscription_name: The name of the subscription to be excluded.
- expiration_date: Date of when the exception expires.

This file should be placed in the same directory as the script or specify the correct path in the script.

## Running the Script
```sh
python -m scripts.get-subscription-owner-details.get_subscription_details
```

## Output Files

After the script execution is complete, you will receive the following files:
__**NOTE:**__ If executing locally, please do not merge these files to repository `AAInternal/GaaS-Policy_as_Code`.

- `subscriptions_data.json` - This file contains subscription details along with the list of owners and contributors directly assigned at the subscription scope (excluding those inherited from the management group scope). If any owner or contributor is a group with nested groups, the script ensures that all users or members under each group are captured.
- `subscriptions_over_3_owners.json` - This file contains details of the subscription that has more than three owners.
- `subscriptions_report.xlsx` - This file is an export/conversion of the above JSON file (subscriptions_data.json) to an Excel spreadsheet, facilitating the creation of pivot tables to analyze the number of owners per subscription.
- `subscriptions_report.html` - This file contains details of the subscription that has more than three owners in html format to be consumed by github workflow
