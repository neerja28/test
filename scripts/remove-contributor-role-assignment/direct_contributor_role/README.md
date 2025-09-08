				              Direct Contributor Access Script

## Prerequisite:
  - SPN: dt-p-CldGovAuto-roleassignmentcleanup-sp
  - Role Assignment: AA-UserAccess-ReadDelete
## Direct Role Assignments Query:
 - https://app.sonraisecurity.com/App/Search?searchId=d6cd8f3c-8da8-4950-a53a-d345c96bfecf&view=results
## How to Run the script:
  - Install of the PowerShell 7.4.5
  - Setup of the \Users\<userid>\Documents\PowerShell> Microsoft.PowerShell_profile.ps1 file add below entries
      $Env:ARM_CLIENT_ID="<value>"
      $Env:ARM_CLIENT_SECRET="<value> "
      $Env:ARM_SUBSCRIPTION_ID="<value>"
      $Env:ARM_TENANT_ID="<value>"
  - Execute the script in DryRun mode:
      "<path>\scripts\ remove-contributor-role-assignment \direct_contributor_removal.ps1" -DryRun 
  - Execute the script in prod mode:
      "<path>\scripts\ remove-contributor-role-assignment \remove-contributor-role-assignment\ direct_contributor_removal.ps1" 

                  Direct Contributor Access Script ReadMe (Testing Locally)
## PreRequisite:
  - Get the resource group created by the GaaS MG owners.
  - Create the SPN using developer.aa.com portal.
  - Login to Azure portal and assign SP role to AA-UserAccess-ReadDelete_Dev
  - Activate the RG role to add the role assignments.
  - Create direct Contributor role (permanent) to test the remove of the role assignments.
## How to Run the script:
  - Install of the PowerShell 7.4.5 or latest
  - Setup of the \Users\<userid>\Documents\PowerShell> Microsoft.PowerShell_profile.ps1 file add below entries
     	$Env:ARM_CLIENT_ID="<value>"
    	$Env:ARM_CLIENT_SECRET="<value> "
    	$Env:ARM_SUBSCRIPTION_ID="<value>"
    	$Env:ARM_TENANT_ID="<value>"
  - Execute the script in DryRun mode:
    "<path>\scripts\remove-contributor-role-assignment\direct_contributor_removal.ps1" -DryRun 


## How to Run the script for Subscription owners:
  - Install of the PowerShell 7.4.5 or latest
  - Setup of the \Users\<userid>\Documents\PowerShell> Microsoft.PowerShell_profile.ps1 file add below entries
     	$Env:ARM_CLIENT_ID="<value>"
    	$Env:ARM_CLIENT_SECRET="<value> "
    	$Env:ARM_SUBSCRIPTION_ID="<value>"
    	$Env:ARM_TENANT_ID="<value>"
  - Execute the script in DryRun mode:
    "<path>.\direct_contributor_removal.ps1 -InputFile "<path>\<file>.csv" -UserPrincipal -dryRun -SubOwners




