# Azure Policy Exceptions
There are certain use cases where a team may need an exception in order to reconfigure resources, create certain resources or migrate resources. In these cases, the product team will need to request a policy exception. This exception will allow teams to bypass a policy in order to accomplish what they need.

*Be aware that exceptions should have a timeline before being granted. Most exceptions will not be permanent and if there is a need for a permanent exception, please be prepared to provide sufficient justification. If there is no timeline provided, exceptions will be honored for one year after the initial approval*

If you are looking to leverage a Restricted or Unused Service, please reference this documentation.
[Restricted and Unused Services](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/docs/exceptions/RESTRICTEDSERVICES.md)

## Common Exception Requests
This section will highlight the policies for which we receive the most exception requests. Please note that they are sorted by Azure resource.

### Azure Region/Location

#### _Allowed Locations_

Location policies are implemented at several scopes with different locations, few subscriptions have policies for specific locations based on their requirements.

- Non-Production Management Group - "eastus","westus","centralus","eastus2","northcentralus","southcentralus","westcentralus","westus2"

- Production Management Group - "eastus","westus","northcentralus"

If there is a need for a new location, check with your subscription owner and enterprise architect. You will also need approval from the Tech Strategy Governance(TSG) team. Please check the link below for more information on AA approved locations and how to reach the TSG team.

- [TSG Runway Page](https://developer.aa.com/docs/default/component/tech-strategy-and-governance#structural-view)

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/Allowed%20locations/assign.np.NON-PROD-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/Allowed%20locations/assign.p.PRODUCTION-MG.json)

### Virtual Machines

#### _VM Creation not allowed_
This policy will block the creation of new virtual machines (IaaS) in the Azure environment. This policy will NOT impact or shut down the existing VMs.

For exceptions, please work with your respective Enterprise Architect to get their approvals to deploy VMs in Azure.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/virtual-machine/VM%20Creation%20Not%20Allowed/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/virtual-machine/VM%20Creation%20Not%20Allowed/assign.p.PRODUCTION-MG.json)

#### _Enforce Virtual Machines are utilizing Managed Disks_
Managed disks are by default encrypted on the underlying hardware so no additional encryption is required for basic protection, it is available if additional encryption is required. Managed disks are by design more resilient that storage accounts.
This policy will block any VM creation with unmanaged disks.

To create an exception, please work with your respective Enterprise Architect and the Security Team (dl_cs-consulting@aa.com) to get their approval to deploy VM with unmanaged disks.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/virtual-machine/Enforce%20VM%20managed%20disks/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/virtual-machine/Enforce%20VM%20managed%20disks/assign.p.PRODUCTION-MG.json)

### Storage Accounts

#### _Enforce storage account public access_
This policy disables anonymous access to blob containers and disallows blob public access on the storage account. This policy will block the creation of any Storage Account with public access set to true. The default is true and must be changed to false. 

To create an exception, please work with the Security Team (dl_cs-consulting@aa.com) to get their approval to deploy a storage account with public access enabled.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/storage-accounts/Enforce%20storage%20account%20public%20access/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/storage-accounts/Enforce%20storage%20account%20public%20access/assign.p.PRODUCTION-MG.json)

#### _Enforce storage accounts secure transfer is enabled_

Engage the Security Team (dl_cs-consulting@aa.com) by filing a Cybersecurity policy exception request seeking approval.

Once approved, please seek approval from your Enterprise Architect and Managing Director.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/storage-accounts/Enforce%20storage%20account%20secure%20transfer/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/storage-accounts/Enforce%20storage%20account%20secure%20transfer/assign.p.PRODUCTION-MG.json)

### Networking

#### _Ensure that HTTP access from the Internet is evaluated and restricted for VMs and NSGs_
This policy will ensure HTTP access from the Internet is evaluated and restricted for VMs and NSGs in both non-production and production Azure subscriptions.

Review your request with the PTL or application owner to ensure that the request is valid and necessary. Once reviewed, request an email approval from the PTL or application owner.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/monitoring/Enforce%20Network%20Security%20Group%20HTTP%20Access/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/monitoring/Enforce%20Network%20Security%20Group%20HTTP%20Access/assign.p.PRODUCTION-MG.json)

#### _Ensure no Public IPs (PIP) in Azure Resource Groups_

By default, Public IPs are not allowed in Azure. If there is a need for PIP, architecture must be reviewed/approved by the Security Team (dl_cs-consulting@aa.com)

- [_Policy Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/initiatives/networking/Enforce%20no%20PIPs%20unless%20in%20a%20Network%20RG/assign.p.AA_GLOBAL-MG.json)

### Database Services

#### _Block creation of Azure PostgreSQL Flexible Server with public access_
This policy will prevent the creation of a new Azure PostgreSQL flexible server with public access in both non-production and production Azure subscriptions.

To request an exception for the creation of a new Azure PostgreSQL flexible server with public access, the Product team must get approval from the Security Team (dl_cs-consulting@aa.com)

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Block%20creation%20of%20Azure%20PostgreSQL%20Flexible%20Server%20with%20Public%20access/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Block%20creation%20of%20Azure%20PostgreSQL%20Flexible%20Server%20with%20Public%20access/assign.p.PRODUCTION-MG.json)

#### _Enforce Azure PostgreSQL Single Server "Allow Access to Azure Services" is disabled_

This policy will enforce Azure PostgreSQL Single Server "Allow Access to Azure Services" is disabled in both non-production and production Azure subscriptions.

Review your request with the PTL or application owner to ensure that the request is valid and necessary. Once reviewed, request an email approval from the PTL or application owner.

- [_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Enforce%20PostgreSQL%20Single%20Server%20Allow%20all%20Azure%20Services%20is%20disabled/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Enforce%20PostgreSQL%20Single%20Server%20Allow%20all%20Azure%20Services%20is%20disabled/assign.p.PRODUCTION-MG.json)

#### _Block creation of Azure MySQL Flexible Server with Public Access_
This policy will prevent the creation of Azure MySQL Flexible Server with Public Access in both non-production and production Azure subscriptions.

To request approval for the creation of a new Azure MySQL flexible server with public access, the Product team must get approval from the Security Team (dl_cs-consulting@aa.com).

- [_Non-Production Assignment File_](http://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Block%20creation%20of%20Azure%20PostgreSQL%20Flexible%20Server%20with%20Public%20access/assign.np.NON-PRODUCTION-MG.json)

- [_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/database-services/postgresql/Block%20creation%20of%20Azure%20PostgreSQL%20Flexible%20Server%20with%20Public%20access/assign.p.PRODUCTION-MG.json)

## Requesting a Policy Exception

### Step 1: Gather the necessary approvals
Below is a list of the policies we recieve the most exception requests for. Please review this list before the exception request is created as these policies require additional approval outside the GaaS.

[Common Exception Requests](#common-exception-requests)

For some policies you will have to request approval from you respective Enterprise Architect. Please see the list below for who to contact regarding this kind of approval.
- Hyder Alkasimi - AOT org
- PJ Gorman - CT org
- Karthick Jenadoss - Corp Tech org
- Keith Murry- CSTRM org
- Kalyan Kalyanaraman - I&O org
- TBD - TnT/Kmac org

If the policy you are seeking an exception for is not in the list above, you can move on to the next step.

### Step 2: Create a fork of this repo and find the correct assignment file
All policy assignments can be found under the [Policies Folder](https://github.com/AAInternal/GaaS-Policy_as_Code/tree/main/azure/policies). They are sorted by Azure resource and the policy name. 

Please note that each policy has a 'NON-PRODUCTION-MG'and 'PRODUCTION-MG' assignment file. These files correspond to the non-prod and prod subscriptions. 
  
If you are making changes to a non production subcription such as 'aa-aot-nonprod-spoke', you will be making changes to the 'NON-PRODUCTION-MG' assignment file and vice versa.

### Step 3: Add the resource ID to the assignment file
The policy assignement should look like the example below. You will need the [resource ID](#what-is-a-resource-id) for the resource group/resource that requires the exception. The resource ID will be added to the "notScopes" array. Since this is a list structure please add a comma between entries.

```json
{
  "properties": {
    "displayName": "Region Specification Assignement - Example",
    "policyDefinitionId": "",
    "scope": "/providers/Microsoft.Management/managementGroups/AA_POLICY_TEST",
    "notScopes": [],
    "parameters": {
      "allowedLocations": {
        "value": ["eastus"]
      }
    },
    "metadata": {},
    "enforcementMode": "Default",
    "nonComplianceMessages": []
  },
  "id": "",
  "type": "",
  "name": "GaaSPolicy_example",
  "location": "eastus"
}
```

```json
{
  "properties": {
    "displayName": "Region Specification Assignement - Example",
    "policyDefinitionId": "",
    "scope": "/providers/Microsoft.Management/managementGroups/AA_POLICY_TEST",
    "notScopes": [
      "subscriptions/e39ceb7a-6195-4eee-b1d5-235f2d68dd87/resourceGroups/cor-n-zeaus-rmde-rg",
      "/subscriptions/55f702f9-17ee-4d42-8da3-3f0bc97c4158/resourceGroups/Zab-policies-test/providers/Microsoft.Storage/storageAccounts/replaceiptest"
      ],
    "parameters": {
      "allowedLocations": {
        "value": ["eastus"]
      }
    },
    "metadata": {},
    "enforcementMode": "Default",
    "nonComplianceMessages": []
  },
  "id": "",
  "type": "",
  "name": "GaaSPolicy_example",
  "location": "eastus"
}
```
### Step 4: Create a PR against the nonprod branch on GaaS-Policy_as_Code
Once the changes are made to the correct assignment file, create a PR against the __nonprod__ branch AND use the __'ex:'__ prefix in the title of all exception PRs.

 `Please make sure the base branch is nonprod and the PR title includes the 'ex:' prefix. This will ensure our automation is triggered and the correct team members are notified`

Once the PR is created please attach an image/pdf/file of the necessary approvals as comment on the PR.

The GaaS team will then review and merge the PR to grant the exception. The GaaS team will take care of pushing your changes into the main branch.

It may take up to 20 minutes for the exception to take effect in the corresponding environment.

## FAQ's

### What is a resource ID?
A resource ID is used by Azure to identify a specific resource. It is a unique identifier for an Azure resource.
You will need the resource ID of the resource/resource group that requires the exception. The resource ID can be found via the Azure portal or within the deployment code used to create the resource.

- __Resource ID Structure(Resource Group)__
`subscriptions/{subscription-id}/resourceGroups/{resource-group-name}`

- __Resource ID Example(Resource Group)__
`subscriptions/e39ceb7a-6195-4eee-b1d5-235f2d68dd87/resourceGroups/cor-n-zeaus-rmde-rg`

- __Resource ID Structure__
`subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-type}/{type}/{resource-name}`

- __Resource ID Example__
`/subscriptions/55f702f9-17ee-4d42-8da3-3f0bc97c4158/resourceGroups/Zab-policies-test/providers/Microsoft.Storage/storageAccounts/replaceiptest`

### How long does it take to review an exception request?
Once the correct approvals are provided, the PR will be merged within 24 hours. The sooner an app team can acquire the needed approvals, the faster we can process an exception. GaaS will reach out if we require more information via the pull request.

### Who do I reach out too to get approvals?
We recommend email as the best method to receive approvals. Please attach a screenshot of the approval email in the pull request once it has been obtained. Below are contacts for approvals.
 - Security Team - dl_cs-consulting@aa.com
 - Tech Strategy Governance(TSG) - [TSG Runway Page](https://developer.aa.com/docs/default/component/tech-strategy-and-governance#structural-view)
 - Tech Radar - https://github.com/AAInternal/TechRadar/issues
 - Enterprise Architects
   - Hyder Alkasimi - AOT org
   - PJ Gorman - CT org
   - Karthick Jenadoss - Corp Tech org
   - Keith Murry- CSTRM org
   - Kalyan Kalyanaraman - I&O org
   - TBD - TnT/Kmac org

### I need to add resources to an existing exception, do I need to get new approvals?
If a user needs to add resources or is expanding the scope for an existing exception that has already been approved, we may ask the user to collect new approvals. Generally, as long as it has been less than a year since the approval was granted, we will not require another exception request/new approvals. However, if there are changes to the exception process (new approvals, resource limits, etc) we may ask the requestor to submit a new request for review.

### Are exceptions tied to a resource or application or shortname? What is the scope of an exception? Do we need an exception for each RG that we create?
Exceptions are granted at the scope the requesting team provides. Generally, exceptions are granted at the resource group level and will only be active for that resource group and the resources that are created within it. 

Exception are not tied to an app shortname or a specific application as they are meant to be used for single initiative the team is working on.

Teams can add resources/resource groups as long as it has been less than a year since the initial approval and there is not a drastic scope change. (Expanding from an resource group to a subscription, or from a single resource to a resource group)

### If you have any other questions or feedback, please reach out to DL_gaas@aa.com or post a message in the #topic-cloud-governance Slack channel

