# Azure Policy Exemptions
This guide will explain the structure and the process for creating exemptions through the GaaS infrastructure engine. Exemptions allow us to establish expiration dates for policy exceptions and provide a more solidified way to document exceptions that have been requested/approved.

## Exemption Folder Structure
Exemptions will exist as a json object via a .json file that will be read by the helper terraform modules to accurately read the json parameters and translate it into an Azure RM Module.

*Because we are using the Azure RM module, certain parameters are not supported such as resource selectors. They can exist within the json object but they will not be translated into the terraform module.*

The folder structure for exemptions will be as follows:

- Deploy Function App (Linux) Logs to CSTRM Event Hub
    - assign.dev.AA_POLICY_TEST.json
    - assign.np.NON-PRODUCTION-MG.json
    - assign.p.PRODUCTION-MG.json
    - exemptions
      - assign.dev.exemption-zabpoliciestest.json

The exemption files will live in an 'exemptions' folder found within policy folder. This will help keep exemptions for the same policies in one place.

*If there is no exemptions folder for a policy, please create one before continuing*

## Exemption Creation
When creating a new exemption, the file should be created within the 'exemptions' folder and should follow the following naming convention.

`exemption.(env).(resource-name).json`

Env is the acronym for the environment the exception will live in. It should match the same environment as the policy that it is targeting. Possible values are 'dev', 'np' and 'p'.

Resource name will be the name for the resource that is being exempted. This could be a resource group, subscription, resource or management group. For subscriptions please use the subscription name not the subscription ID.

`exemption.dev.zabpoliciestest.json` - This would be an exemption for the resource group zab-policies-test in the dev environment.

Below you can find a example exemption/template for reference.

[Example Exemption](../../azure/initiatives/monitoring/Deploy%20Function%20App%20(Linux)%20Logs%20to%20CSTRM%20Event%20Hub/exemptions/exemption.dev.zabpoliciestest.json)

The example below will define each parameter and how it is used 

[Exemption Reference](../../azure/initiatives/monitoring/Deploy%20Function%20App%20(Linux)%20Logs%20to%20CSTRM%20Event%20Hub/exemptions/exemption.dev.zabpoliciestest.jsonc)
`
*This exemption file is only for reference and to be used as example. Do not use the .jsonc format for actual exemption creation*

Please be aware of the metadata that is required for the exemption to be valid. The following parameters are required:

```json
      "metadata": {
        "requestedBy": "Zab - GaaS",
        "PolEx": "Pol-EX 1234",
        "aa-app-shortname": "CldGovAuto",
        "approvedBy": "Zab - GaaS",
        "approvedOn": "2025-05-20T00:00:00.0000000Z"
      },
```

These parameters are used to track who requested the exemption, the security exception number, the application short name, and who approved the exemption along with the date it was approved.

For any date times used within the exemption .json please use the ISO (UTC) 8601 format. This is important for consistency and to ensure that the date is correctly interpreted by the system.

### Exemption Modules
Much like policy assignments, there will be a module created for each exemptions folder. These can be found under components -> policy -> exemption -> exemption_definitions.tf

[Exemption Modules](../../components/exemptions/exemptions.tf)

This module needs to be present in order for the terraform code to read the exemption json.

```
module "ex_allowed_locations" {
  display_name_prefix  = var.display_name_prefix
  ex_fileset_filter      = var.ex_fileset_filter
  path_to_def          = "./azure/policies/Allowed locations/exemptions"
  source               = "../../exemptions"
}
```

The only difference between these modules is the name and the path_to_def parameter. This parameter points to the location of the exemptions folder for the policy. The path should be relative to the module that is calling it.

Most of these modules have already been created. However, if you need to create a new module for a policy that has exemptions, you can use the following template:

```
module "ex_[policy_name]" {
  display_name_prefix  = var.display_name_prefix
  ex_fileset_filter      = var.ex_fileset_filter
  path_to_def          = "./azure/policies/[policy-group]/[policy_name]/exemptions"
  source               = "../../exemptions"
}
```
Please be sure the path being passed is valid and is referencing the correct exemptions folder for the policy.

### Final Considerations

- **Exemption Expiration**: Each exemption should have an expiration date. This is important for tracking and ensuring that exemptions are not permanent unless explicitly intended.
- **Exemption Scope**: The scope of the exemption should be within the policy assignment scope and the resource ID should be valid. More information on resource ID can be found here: [Resource ID Format](../exceptions/POLICYEXCEPTIONGUIDE.md#what-is-a-resource-id).
- **Exemption Justification**: The approvals required for exceptions are still required. Enterprise Architects and Security Architects should still be consulted as necessary.
