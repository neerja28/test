# Azure Unused Service Detection and Blocking

This Python script automatically detects and restricts unused Azure services using Azure Policy definitions. It achieves this by updating policy files within a Git repository, enabling a streamlined and version-controlled approach to managing Azure service restrictions.

## Purpose
The primary goal of this script is to enhance governance and cost optimization within your Azure environment by identifying and preventing the creation of Azure services that are not actively utilized. It accomplishes this by intelligently modifying Azure Policy definitions in a Git repository, ensuring a traceable and auditable process.

## Terminology
In this documentation, we use the terms "Namespace" and "Provider" interchangeably. They refer to the same concept within the Azure context.

## Configuration
The core of this script relies on the `final_schema` file, which contains the details about which resource types under specific namespaces/providers should be blocked, allowed, or have exceptions.

## How it Works

1. **Input & Configuration**:
   - The script leverages a set of input JSON files defining:
      - Core services
      - Allowed services
      - Blocked services
      - Exception services (managed via a separate policy)

2. **Azure Data Collection**:
   - Azure Resource Manager (ARM) API: Queries the ARM API at the tenant level to gather a comprehensive list of all available Azure services.
   - Azure Resource Graph: Executes a query using Azure Resource Graph to identify Azure services actively used across all scopes.
   - Custom Resource Types: Handles the discovery of custom resource types that might not be readily available through the ARM API.

3. **Unused Service Identification**:
   - Compares the list of all available services against the actively used services, taking into account core, allowed, and blocked services, to determine the list of unused services.

4. **Policy Update & Git Integration**:
   - If new unused services are detected, the script:
      - Creates a new branch for these changes.
      - Updates the Audit Unused resources Azure Policy JSON files in the specified Git repository (GaaS-Policy_as_Code).
      - Raises a Pull Request (PR) for review and potential merging, incorporating the updated policy definitions.

5. **Schema Generation & File Management**:
   - The script generates a structured final_schema.json that details the classification of each Azure service (allowed, restricted, exception) and associated namespaces.
   - An interim schema file is created during the update process to track changes.

## Local Development and Execution

### Prerequisites

Before running this script locally, make sure you have the following prerequisites:

- Python 3.11 or higher.
- Environment Variables:
   - GIT_REPO: The full name of your Git repository (e.g., your-org/your-repo)
   - PAT_TOKEN: A GitHub Personal Access Token with appropriate permissions to interact with your repository
- Azure CLI: Installed and configured with an active login session

### Steps

Clone the repository:

```shell
git clone <your-repository-url>
cd GaaS-Policy_as_Code
```

Install the dependencies

```shell
pip install -r scripts/azure-block-unused-resources/requirements.txt
```

Run python script

```shell
export GIT_REPO="your-org/your-repo"
export PAT_TOKEN="your-github-pat-token"
python -m scripts.azure-block-unused-resources.azure_deny_service_audit
```
