using namespace System.Collections.Generic
Param(
    [switch]$DryRun,
    [string]$InputFile,
    [switch]$UserPrincipal,
    [switch]$SubOwners

)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$parentDir = Split-Path -Parent $scriptDir

# Connect to Azure
$tenantId = (Get-Item Env:ARM_TENANT_ID).value
$clientId = Get-Item Env:ARM_CLIENT_ID
$clientSecret = Get-Item Env:ARM_CLIENT_SECRET
$securePassword = ConvertTo-SecureString -String $clientSecret.Value -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId.Value, $securePassword

$subscription = (Get-Item Env:ARM_SUBSCRIPTION_ID).Value
$subSet = [List[PSCustomObject]]::new()

Function main {
    Write-Host "Connecting to Azure...$tenantId"
    if ($UserPrincipal) {
        # Use personal credentials
        Connect-AzAccount -Tenant $tenantId -Subscription $subscription        
    }
    else {
        Connect-AzAccount -Credential $credential -TenantId $tenantId -ServicePrincipal
    }



    # Check if connected to Azure
    $context = Get-AzContext
    if ($null -eq $context) {
        Write-Host "Failed to connect to Azure. Please check your credentials."
        return
    }
    Write-Host $context


    # Read the CSV file
    Write-Host "Reading CSV file..."
    $csvData = Import-Csv -Path $InputFile
    # Get report output file path
    $outPath = ($InputFile.SubString(0, $InputFile.Length - 4))
    $VERSION = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $reportPath = -join ($outPath, "_OUT_", $VERSION, ".csv")
    Write-Host "output file CSV file..." $reportPath

    # Check if CSV file is read correctly
    if ($null -eq $csvData) {
        Write-Host "Failed to read CSV file. Please check the file path and format."
        return
    }
    Write-Host "CSV file read successfully."

    # Create an array to store the results
    $results = @()


    Write-Host "DryRun" $DryRun

    # Loop through each entry in the CSV file
    foreach ($row in $csvData) {
        $srnscopeelig = $null
        $srnscopeactive = $null
        $srnscope = $null
        $subscriptionId = $null

        $srnprincipalId = $row."Resource Srn"
        Write-Host "Reading new $srnprincipalId"

        $srnscope = $row."Policy Scope"
        $srnscopeelig = $row."Policy Eligible PIM Scope"
        $srnscopeactive = $row."Policy Active PIM Scope"
        Write-Host "Reading srnscopeactive $srnscopeactive"
        Write-Host "Reading srnscope $srnscope"
        Write-Host "Reading srnscopeelig $srnscopeelig"

        # Create a hashtable to store the result of each operation
        $result = [ordered]@{
            'PrincipalId'   = $srnprincipalId
            'Scope'         = $srnscope
            'EligibleScope' = $srnscopeelig
            'ActiveScope'   = $srnscopeactive
            'Status'        = $null
            'Error'         = $null
            'UserType'      = $null

        }

        if (-not [string]::IsNullOrEmpty($srnscope)) {

            $subscriptionId = ($srnscope -split '/')[2]
            $scope = $result.Scope -replace '(.*)\*', '$1'
            Write-Host "now the srnscope is $scope"

        }
        elseif (-not [string]::IsNullOrEmpty($srnscopeelig)) {
            $subscriptionId = ($srnscopeelig -split '/')[2]
            $scope = $result.EligibleScope -replace '(.*)\*', '$1'
            Write-Host "now the srnscopeelig is $scope"

        }
        else {
            $subscriptionId = ($srnscopeactive -split '/')[2]
            $scope = $result.ActiveScope -replace '(.*)\*', '$1'
            Write-Host "now the srnscopeactive is $scope"

        }

        try {
            # Change the active subscription
            Write-Host "Changing active subscription to: $subscriptionId"
            Set-AzContext -SubscriptionId $subscriptionId

            $principalId = $result.PrincipalId -replace 'srn:azure:ActiveDirectory::49793faf-eb3f-4d99-a0cf-aef7cce79dc1/User/', ''
        
            $user = Get-AzADUser -ObjectId $principalId

            $userObject = [PSCustomObject]@{
                Id                = $user.Id
                DisplayName       = $user.DisplayName
                MailNickName      = $user.MailNickName
                JobTitle          = $user.JobTitle
                UserPrincipalName = $user.UserPrincipalName
            }

            # Zacct job title empty
            if ($userObject.JobTitle.Length -eq 0) {
                $result.UserType = "zAccount"
                throw "User Type is zAccount $userObject.DisplayName"
            }
            $filter = "roleDefinitionId eq '/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' and principalId eq '$principalId' "
            $roleDefinitionId = "/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"

            #de-dup of the subscriptions
            if ($SubOwners) {
                if (-not $subSet.Contains($subscriptionId)) {
                    if ($subscriptionId -ne $null) {
                        $subSet.Add($subscriptionId)
                    }
                }
            } 


            if (-not [string]::IsNullOrEmpty($srnscopeelig)) {
                Write-Host "Before Getting eligible role assignment for PrincipalId: $result.PrincipalId at Scope: $result.EligibleScope"
                $scopeWithoutSlash  = $scope -replace "^/", ""
                Write-Host $scopeWithoutSlash    

                $schedules = Get-AzRoleEligibilitySchedule -Scope $scope -Filter $filter
            
            
                if ($null -eq $schedules) {
                    Write-Host "No role eligibility schedules found for PrincipalId: $PrincipalId"
                }
                else {
                    Write-Host "schedules $schedules"
                    Write-Host $schedules.Name
    
                    $guid = New-Guid
                    if ($DryRun) {
                        Write-Host "***Dry-run**** Revoked contributor eligible role for PrincipalId: $principalId at Scope: $scope"
                        $result['Status'] = '***dry run***eligible role assignment revoked'
                    }
                    else {
                        try {
                            New-AzRoleEligibilityScheduleRequest -RequestType "AdminRemove" -RoleDefinitionId $roleDefinitionId `
                                -Scope $scopeWithoutSlash `
                                -PrincipalId $principalId `
                                -Name $guid `
                                -Justification "revoked Contributor eligibility role assignment" -Debug

                            $result['Status'] = 'eligible role assignment revoked'


                        }
                        catch [System.Management.Automation.ActionPreferenceStopException] {
                            $errorMessage = $_.Exception.Message
                            Write-Host "Failed to revoke eligible role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                            $result['Status'] = 'failed'
                            $result['Error'] = $errorMessage
                        }
                        catch {
                            Write-Host "An error occurred while removing the eligible role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                            $result['Status'] = 'failed'
                            $result['Error'] = $errorMessage
                        }

                    }
                }
                $srnscopeelig = $null
        
            }
            elseif (-not [string]::IsNullOrEmpty($srnscopeactive)) {
                $roleAssignment = Get-AzRoleAssignment -ObjectId $principalId -Scope $scope -ErrorAction Stop

                Write-Host $roleAssignment
         
                # Check if the role assignment exists
                if ($null -eq $roleAssignment) {
                    Write-Host "No matching active role assignment in Azure for PrincipalId: $principalId at Scope: $scope"
                    Write-Host "Before Getting active time bound role assignment for PrincipalId: $result.PrincipalId at Scope: $result.ActiveScope"
                    try {
                        $activeTimeBoundRoleAssignment = Get-AzRoleAssignmentSchedule -Scope $scope -Filter $filter
                        Write-Host $activeTimeBoundRoleAssignment.Id
                        $scopeWithoutSlash = $scope -replace "^/", ""
        
                        if ($null -eq $activeTimeBoundRoleAssignment) {
                            Write-Host "No active time-bound role assignment schedules found for PrincipalId: $PrincipalId"
                        }
                        else {
                            Write-Host "schedules $activeTimeBoundRoleAssignment"
                            Write-Host $activeTimeBoundRoleAssignment.Name
            
                            $guid = New-Guid
                            if ($DryRun) {
                                Write-Host "***Dry-run**** Revoked contributor active time-bound role for PrincipalId: $principalId at Scope: $scope"
                                $result['Status'] = '***dry run***active time bound role assignment revoked'
                            }
                            else {
                                try {
                                    New-AzRoleAssignmentScheduleRequest -RequestType "AdminRemove" -RoleDefinitionId $roleDefinitionId `
                                        -Scope $scopeWithoutSlash `
                                        -PrincipalId $principalId `
                                        -Name $guid `
                                        -Justification "revoked Contributor active time-bound role assignment" -Debug
        
                                    $result['Status'] = 'contributor active time-bound role revoked'
        
                                }
                                catch [System.Management.Automation.ActionPreferenceStopException] {
                                    $errorMessage = $_.Exception.Message
                                    Write-Host "Failed to revoke contributor active time-bound role for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                                    $result['Status'] = 'failed'
                                    $result['Error'] = $errorMessage
                                }
                                catch {
                                    Write-Host "An error occurred while removing the active time-bound role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                                    $result['Status'] = 'failed'
                                    $result['Error'] = $errorMessage
                                }
        
                            }
                        }
                    }
                    catch {
                        Write-Host "An error occurred while getting the active time-bound role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                        $result['Status'] = 'failed'
                        $result['Error'] = 'No matching role assignment in Azure'
                    }
                }
                elseif ($roleAssignment.RoleDefinitionName -eq "Contributor") {
                    Write-Host "Revoking contributor role for PrincipalId: $principalId at Scope: $scope"
                    if ($DryRun) {
                        Write-Host "***Dry-run**** Revoked contributor role for PrincipalId: $principalId at Scope: $scope"
                        $result['Status'] = '***dry run*** contributor role removed'
                    }
                    else {
                        try {
                            Remove-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName "Contributor" -Scope $scope -ErrorAction Stop
                            $result['Status'] = 'contributor role revoked'
                        }
                        catch [System.Management.Automation.ActionPreferenceStopException] {
                            $errorMessage = $_.Exception.Message
                            Write-Host "Failed to revoke contributor role for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                            $result['Status'] = 'failed'
                            $result['Error'] = $errorMessage
                        }
                        catch {
                            Write-Host "An error occurred while removing the role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                            $result['Status'] = 'failed'
                            $result['Error'] = $errorMessage
                        }
                    }
     
                }
            }
  
        }
        catch {

            $errorMessage = $_.Exception.Message
            Write-Host "An error occurred while getting the role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
            $result['Status'] = 'failed'
            $result['Error'] = $errorMessage

        }
        finally {
            # Add the result to the results array
            $results += New-Object PSObject -Property $result
    
            # Export the results to a CSV file
            $results | Export-Csv -Path $reportPath -NoTypeInformation
        }

    }


    if ($SubOwners) {
        #process to get the SUB owners

        write-host $parentDir\
        . $parentDir\Subscription-owner-list.ps1
        Get-SubOwnerDetail  -SubId $subSet 

    }

}

# Run the Main function
Main
