## 4k Limit  - Role Assignment Revoke Access Script


## 1. Requirements & Prerequistes:
   
   ### 1.1 Azure Authentication:
   - If there is a `SPN` to run the script, refer to the section:  

     ➡️ Settings: [Environment Settings for SPN](#2-environment-settings-for-spn)
     
      OR

   - if the Sub or RG owner using `userprincipal`, refer to the section:

     ➡️ Settings: [Environment Settings for userprincipal](#3-environment-settings-for-userprincipal)
     

  ### 1.2 Azure Authorization (Required Role(s))
   - To remove role assignments at the specified scope, the script requires the `user/SPN` to have at least `ONE` of the following roles.
      - `Owner` – Full access, including RBAC permissions.
      - `RBAC Administrator` – Ability to manage RBAC settings.
      - `User Access Administrator` – Can assign/remove roles and delete custom roles.

  ### 1.3 Input file Preparation:

  - ✅ The main input file of 4k limit should have file with dry run results
      - Example
        - `<inputFile>_DryRun.csv`
        - Content of the file should have `Status` Column with `dry run` data
        - Refer to below on how to run the scrip in dry run mode:  [Dry Run File](#4-how-to-run-the-script)
        - Refer to the dry run output file [Dry Run for Input](#4-result-output)

  - ✅ Summary of precedence of input files preparation: 
    - Scenario 1: If a user (Jhon Smith) to be excluded rom the role assignments removal
      - add the user to the `functional-acct-type-exclusion-list.txt`
      - add the exculsions of `object-type-exclusion-list.txt` for all other users
      - Create all the role assignment in `role-assignment-list.txt`
    - Scenario 2: If a `ServicePrincipal` to be excluded from the role assignments removal
      - add the user to the `object-type-exclusion-list.txt`
      - add any user if needed to the `functional-acct-type-exclusion-list.txt`
      - Create all the role assignment in `role-assignment-list.txt`

  - ✅ Include Resource Group List – `resourcegrp-list.txt`
    - Specify the opt-in RGs:
      ```
      RG1
      RG2
      ```
   
  - ✅ Include Role Assignment List to Revoke – `role-assignment-list.txt`
    - List the opt-in role definitions to revoke:
      ```
      Network Contributor
      Unknown
      Contributor
      Owner
      ```

  - ✅ Principal Type Exclusion – `object-type-exclusion-list.txt`
    - Exclude role assignments based on principal types:
      ```
      ServicePrincipal
      Group
      ```

  - ✅ Account Exclusion – `acct-type-exclusion-list.txt`
    - Exclude specific functional/user accounts
    - Exclude yourself by adding the name if you have RBAC, User Access Admin, or Owner
      ```
      Z123456
      Z1064711
      Doe, John
      ```

  - 💡 Commenting in Input Files
    - You can use `#` to comment out lines in all input files. These lines will be ignored during processing.
    - Example Below   
      ```
      #Key Vault Secrets User
      #Key Vault Data Access Administrator
      #Azure Event Hubs Data Receiver
      #Azure Event Hubs Data Sender
      #Stream Analytics Query Tester
      #Storage Blob Data Reader
      Network Contributor
      Unknown
      Contributor
      Owner

## 2. Environment Settings For SPN
  - Install of the PowerShell 7.5.1
  - Update the profile file at:
    ```powershell
      \Users\<userid>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 
    ```
  - Add below entries
    ```powershell
      $Env:ARM_CLIENT_ID="<value>"
      $Env:ARM_CLIENT_SECRET="<value> "
      $Env:ARM_SUBSCRIPTION_ID="<value>"
      $Env:ARM_TENANT_ID="<value>"
    ```

  
  ## 3. Environment Settings For Userprincipal
  - Install of the PowerShell 7.5.1
  - Update the profile file at:
    ```powershell
      \Users\<userid>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 
    ```
  - Add below entries

    ```powershell
    $Env:ARM_SUBSCRIPTION_ID="<value>"
    $Env:ARM_TENANT_ID="<value>"
    ```

 ## 4. How to run the script:
 
  ### 🧪 Default Mode: Dry Run Enabled (-DryRun $true by default)
  
  - Execute the script for `Subscription scope $DryRun mode`:
    ```powershell
      "<path>\scripts\remove-role-assignments\Remove-Role-Assignments-4kLimit.ps1" -InputFile "<inputfile>.csv"
    ```
  - Execute the script for `RG scope $DryRun Mode`:
    ```powershell
      "<path>\scripts\remove-role-assignments\Remove-Role-Assignments-4kLimit.ps1" -InputFile "<inputfile>.csv" -ResourceGroupScope $true
    ```
  - Note:
      - Simulates execution
      - No changes are made
      - For Testing purpose
    
  ### 🚨 Actual Run: Disable Dry Run (-DryRun $false)

  - Resource Group Scope:
    ```powershell
    "<path>\scripts\remove-role-assignments\Remove-Role-Assignments-4kLimit.ps1" -InputFile "<inputfile>_DryRun.csv" -ResourceGroupScope $true -DryRun $false
    ```
    
  - Subscription Scope:
    ```powershell
      "<path>\scripts\remove-role-assignments\Remove-Role-Assignments-4kLimit.ps1" -InputFile "<inputfile>_DryRun.csv" -DryRun $false
    ```

 ## 4. Result Output

 ### 🧪 Dry Run results
  - check the output of the dry run output that will be the input to the actual run `<inputfile>_DryRun.csv`
  
  ### 🚨 Actual Run Results
  - Check the output at the Resource Group:  `<inputfile>_OUT_SUCCESS_RG.csv`
  - Check the success output at Subscription level: `<inputfile>_OUT_SUCCESS_SUB.csv`



