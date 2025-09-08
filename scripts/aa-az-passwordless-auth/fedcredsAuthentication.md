# Azure Passwordless Authentication with GitHub Actions

## 🚀 Elevate Your Azure Service Principal Game in GitHub Actions! 🚀

Streamline your workflow with Azure Service Principal and ^^Federated Credentials^^! Seamlessly authenticate to Azure directly from your GitHub Actions, ensuring secure and efficient access—without the need for password rotation or storage.

### Why Choose Azure Service Principal with Federated Credentials?

- **Enhanced Security**: Federated credentials eliminate the need for long-lived secrets.
- **Simplified Management**: Easily manage and configure authentication settings within your GitHub repository.
- **Increased Efficiency**: Reduce operational overhead and streamline your CI/CD pipeline with automated and secure Azure authentication.
- **Terraform Compatible**: Utilize this solution with Terraform to automate and manage your infrastructure as code.

**Transform Your Development Workflow Today!**

Experience the seamless integration of Azure Service Principal with Federated Credentials in your GitHub Actions. Boost your productivity, enhance security, and take your projects to the next level.

🔹 **Secure** 🔹 **Efficient** 🔹 **Automated**

**Get Started Now** and revolutionize the way you authenticate to Azure! 🚀

### How to

#### Azure Service Principal Federated Credential Configuration

##### Using the CLI

Below are examples for adding federated credentials to a Service Principal using a Pull Request, Branch Name, and GitHub Environment Name.

#### Environment

##### AZ CLI cmds to generate Fed creds for Non production

```shell
scripts/fed-creds-np.sh
```

##### AZ CLI cmds to generate Fed creds for Production

```shell
scripts/fed-creds.sh
```

##### Using the Portal

1. Go to your service principal in Azure Active Directory > App registrations.
2. Select Certificates & secrets > Federated credentials > Add credential.
3. Choose GitHub Actions as the identity provider.
4. Fill in the required fields:

- Organization: Your GitHub organization or username.
- Repository: Your GitHub repository name.
- Branch: The branch that will trigger the workflow.

5. Click Add to create the federated credential.

#### GitHub Actions Workflow

You can use federated credentials when authenticating to Azure using GitHub Actions and a Service Principal! Notice there is no password being supplied to azure/login, so there’s no need for ^^password storage or rotation^^!

Below is a sample workflow that can be built on top of.

```yaml
name: Deploy to Azure
on:
  push:
    branches:
      - main
 
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
 
    steps:
    - name: Checkout repository
      uses: actions/checkout@v2
 
    - name: Login to Azure
      uses: azure/login@v1
      with:
        client-id: ${{ vars.AZURE_CLIENT_ID }}
        tenant-id: ${{ vars.AZURE_TENANT_ID }}
        subscription-id: ${{ vars.AZURE_SUBSCRIPTION_ID }}
 
    - name: Terraform Init and Apply
      run: |
        terraform init
        terraform apply -auto-approve
```

#### Terraform Configuration

Also ensure you properly set the `azurerm` backend to use OpenID Connect! Below is a sample and versions may be dated.

```text
terraform {
  required_version = ">=1.2.8"
 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.105.0"
    }
  }
 
  backend "azurerm" {
    use_oidc              = true
    use_azuread_auth      = true
  }
}

provider "azurerm" {
  features {}
}
```

