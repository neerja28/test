# Restricted and Unused Azure Services
We are currently restricting Azure Services that are either in the 'Not the droids' category or don't have a Tech Radar disposition. Please open an issue in the Tech Radar GitHub Repository to propose the usage of a restricted Azure Service (Resource Type) https://github.com/AAInternal/TechRadar/issues

The full whole list can be found here.
[Restricted Services in Azure](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/docs/RestrictedServices.xlsx)

The requester will follow the Tech Radar process to get the new service approved.
Once it's approved in Tech Radar, GaaS will remove the restriction. The 

If the new service needs to be purchased (not in the current agreement such as Azure marketplace services), the following additional procurement process needs to be followed.

 - By default, the Azure marketplace is closed until approved by ITVM to open. The requester will contact ITVM to initiate a purchase. This is the same process that exists for any purchase, marketplace or not. 
 - Once an agreement is in place following all approval processes for an agreement, the vendor will deploy a private offer in the marketplace that references the agreement.
 - The requester will reach out to GaaS to request the marketplace be “opened” for the private offer purchase.
- GaaS will confirm with ITVM that the purchase is approved and the private offer conforms to the agreement.

Once the bullets above are completed the marketplace is opened for the purchase.  
Once the purchase is made and configured, the marketplace is closed and the process will need to restarted if there is a need to re-open.

There a few blocked resources that we are accepting exception requests for and that do not need to go through Tech Radar for approval. Please reference those services here.
[Blocked Resources that Allow Exceptions](#blocked-resources-that-allow-exceptions)

If you have any questions regarding the considerations taken when approving a new Azure Service, please reference this outline [Tech Radar Expectations](#expectation-for-alignment-to-tech-radar-for-all-cloud-environments-azure-ibm-oci-and-aws-and-on-premise-environments).

Contact the Tech Radar or GaaS team for any further questions.

## Blocked Resources that Allow Exceptions

#### Block ACR (Azure Container Registry) creation

This policy will block the creation of a new Azure Container Registry (ACR) in Azure. This policy will NOT impact or shut down the existing ACR instances

All resources dependent on ACR will be automatically granted an exception. Currently the only Azure Resource dependent on ACR (Cannot use a third-party registry) is Azure Machine Learning. 
Note: If you are trying to create an Azure resource, and it is dependent on ACR and cannot use another third-party registry, please create an issue in Tech Strategy and Governance.

If resources does not have a dependency on ACR, but the application team needs to use ACR. Please consult TSG representative and get Enterprise Architect approval to create new ACR instance in Azure.

[TSG Runway Page](https://developer.aa.com/docs/default/component/tech-strategy-and-governance#structural-view)

[_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Enforce%20ACR%20creation%20not%20allowed/assign.np.NON-PRODUCTION-MG.json)

[_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Enforce%20ACR%20creation%20not%20allowed/assign.p.PRODUCTION-MG.json)

#### Block ACA (Azure Container Apps) creation

This policy will block the creation of a new Azure Container Apps (ACA) in Azure. This policy will NOT impact or shut down the existing ACA instances.

All resources dependent on ACA will be automatically granted an exception.

If resources does not have a dependency on ACA, but the application team needs to use ACA. Please get TSG representative approval to create new ACR instance in Azure.

[TSG Runway Page](https://developer.aa.com/docs/default/component/tech-strategy-and-governance#structural-view)

[_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20Container%20Apps/assign.np.NON-PRODUCTION-MG.json)

[_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20Container%20Apps/assign.p.PRODUCTION-MG.json)

#### Disable the creation of NAT gateways
This policy will prevent the creation of new NAT Gateways in both non-production and production Azure subscriptions.

To request an exception for the creation of new NAT gateway resources, the requestor must get approval from the Security Team (dl_cs-consulting@aa.com)

[_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20NAT%20gateways/assign.np.NON-PRODUCTION-MG.json)

[_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20NAT%20gateways/assign.p.PRODUCTION-MG.json)

#### Block creation of PostgreSQL Single Server
This policy will prevent the creation of Azure PostgreSQL Single Servers in both non-production and production Azure subscriptions.

Review your request with the PTL or application owner to ensure that the request is valid and necessary. Once reviewed, request an email approval from the PTL or application owner.

[_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Block%20creation%20of%20PostgreSQL%20Single%20server/assign.np.NON-PRODUCTION-MG.json)

[_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Block%20creation%20of%20PostgreSQL%20Single%20server/assign.p.PRODUCTION-MG.json)

#### Block creation of MySQL Single Server
This policy will prevent the creation of MySQL Single Servers in both non-production and production Azure subscriptions.

Review your request with the PTL or application owner to ensure that the request is valid and necessary. Once reviewed, request an email approval from the PTL or application owner.

[_Non-Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20MySQL%20Single%20Server/assign.np.NON-PRODUCTION-MG.json)

[_Production Assignment File_](https://github.com/AAInternal/GaaS-Policy_as_Code/blob/main/azure/policies/unused-services/Restrict%20creation%20of%20Azure%20MySQL%20Single%20Server/assign.p.PRODUCTION-MG.json)


## Requesting a Policy Exception

### Step 1: Gather the necessary approvals
Below is a list of the policies we recieve the most exception requests for. Please review this list before the exception request is created as these policies require additional approval outside the GaaS.

[Common Exception Requests](#common-exception-requests)

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

## Expectation for alignment to Tech Radar for all cloud environments (Azure, IBM, OCI, and AWS) AND on-premise environments
- Technologies deployed in our environment must be represented in Tech Radar and have gone through the defined dispositioning process described therein.
- All team members provisioning new resources in any environment should validate their representation in Tech Radar prior to doing so.
- Technologies that are constrained from usage (either due to being explicitly restricted or due to being categorized as 'Eliminate' in Tech Radar) require an exception recorded by the Governance as a Service team prior to provisioning.
- Exceptions will be evaluated on the following basis:
    - Explicit need for the resource type in question as opposed to alternative adopted standards
    - Resiliency, availability, and reliability considerations 
    - Security considerations
    - Regulatory requirements
- Exception Review
    - Exceptions must be reviewed by the named Enterprise Architect for the relevant domain
        - Airline Operations Technology: Hyder Alkasimi or Prem Vijayan
        - Commercial Technology: PJ Gorman
        - Office of the CTO (Data, Operations Research, Developer Platform, Emerging Technology): Karthick Jenadoss
        - Corporate Technology:  Steve Bishop
        - Infrastructure and Operations:  Kalyan Kalyanaraman or Mike Abella
        - Security: Keith Murry and Samir Shah
        - Technology Transformation: any of the above Enterprise Architects
    - Any relevant security considerations unique to the usage of the constrained resource type (including externally mandated security regulations, such as FAA, TSA etc.) must be reviewed by the Cybersecurity organization
    - If the intended usage of the constrained resource type involves the use of sensitive or restricted personal data, a Data Privacy consultation will also be required
- Auditing
    - Monthly auditing of in-use technologies will be conducted to ensure compliance with this policy.   
