# -------------------------------------------------------------------------------
# Script: Remove-AaAzureContributorAccess.ps1
# -------------------------------------------------------------------------------
# Usage: 
#    .\Remove-AaAzureContributorAccess.ps1 -InputFile <Sonrai CSV File> [-WetRun] [-UserPrincipal]
# 
# Examples:
#    .\Remove-AaAzureContributorAccess.ps1 -InputFile ".\AA sonrai.csv" # By default, Dry Run is performed and Service Principal is used
#    .\Remove-AaAzureContributorAccess.ps1 -InputFile ".\AA sonrai.csv" -UserPrincipal
# -------------------------------------------------------------------------------
# You can Set Alias for this script.
#    Set-Alias -Name rmca -Value ".\Remove-AaAzureContributorAccess.ps1"
# To verify the alias:
#    Get-Alias -Name rmca
# Example:
#    rmca -InputFile "AA - Group Contributor (Custom)  - Members (AA-Custom) -RG results - 2024-08-06T15_10_21.csv"
# -------------------------------------------------------------------------------

using namespace System.Collections.Generic

# ------------------------------------
# Command line parameterized arguments
# ------------------------------------
Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $InputFile,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $WetRun,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $UserPrincipal,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $RGAADOwners,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $SubOwners,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $AADContOwners
)

# -----------------
# Install Az Module
# -----------------
# Set-ExecutionPolicy Unrestricted
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
# Get-ExecutionPolicy
# Get-InstalledModule Az
# Install-Module -Name Az -Repository PSGallery -AllowClobber -Scope AllUsers -Force
# Update-Module -Name Az -Force
# -----------------
# Import the required Az module (Optional - Installed module does not require Import)
# Import-Module Az -DisableNameChecking -WarningAction Ignore

# ------------------------------------------------
# Get-AaDateTimeAsString
# ------------------------------------------------
[List[PSCustomObject]]$AADContOwnerList = [List[PSCustomObject]]::new()
[List[PSCustomObject]]$RgOwner = [List[PSCustomObject]]::new()
[List[PSCustomObject]]$SubOwner = [List[PSCustomObject]]::new()
[List[PSCustomObject]]$aadGroupOwners = [List[PSCustomObject]]::new()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Function Get-AaDateTimeAsString {
    return Get-Date -Format "yyyy-MM-dd_HH-mm"
}

# ------------------------------------------------
# Function: Read-AaCSV
# Description: Read the CSV file and return an object
# ------------------------------------------------
Function Read-AaCSV {
    param (
        [Parameter(Mandatory)]
        [string]$CsvFile
    )

    # Read the CSV file
    Write-Host "** Reading CSV file... $CsvFile"
    $csvData = Import-Csv -Path $CsvFile

    # Check if CSV file is read correctly
    if ($null -eq $csvData) {
        Write-Host "Failed to read CSV file."
        return
    }
    Write-Host "** CSV file read successfully."

    return $csvData
}

# ------------------------------------------------
# Function: Connect-AaAzure
# Description: Connect to Azure ARM and validate the connection
# ------------------------------------------------
Function Connect-AaAzure {
    param(
        [parameter(Mandatory = $False)]
        [switch]$UserPrincipal,
        [parameter(Mandatory = $False)]
        [switch]$Force
    )
    # Log param
    Write-Host "** Connect-AaAzure -UserPrincipal $UserPrincipal"
    
    # Check if connected to Azure
    $context = Get-AzContext
    if ($null -ne $context) {
        Write-Host "** Already Connected to Azure"
        Write-Host "^^ AzContext: $($context.Name)"
        
        if ($Force) {
            Disconnect-AzAccount
            Write-Host "** Force Disconnected from Azure"
        }
        else {
            return $context
        }
    }

    # Get environment variables
    $tenantId = (Get-Item Env:ARM_TENANT_ID).Value

    if ($UserPrincipal) {
        $subscription = (Get-Item Env:ARM_SUBSCRIPTION_ID).Value
        # Use personal credentials
        Connect-AzAccount -Tenant $tenantId -Subscription $subscription        
    }
    else {
        # Use Service Principal
        # Get environment variables    
        $clientId = (Get-Item Env:ARM_CLIENT_ID).Value
        $clientSecret = (Get-Item Env:ARM_CLIENT_SECRET).Value

        $securePassword = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $securePassword

        # Use service principal
        Connect-AzAccount -Credential $credential -Tenant $tenantId -ServicePrincipal
    }

    # Check if connected to Azure
    $context = Get-AzContext
    if ($null -ne $context) {
        Write-Host "** Connected to Azure"
        Write-Host "^^ AzContext: $($context.Name)"
        
        return $context
    }
    else {
        Write-Host "*** Failed to connect to Azure. Please check your credentials."
        throw "Failed to connect to Azure."
    }
    # Add a delay
    # Start-Sleep -Seconds 3
}

# ------------------------------------------------
# Function: Disconnect-AaAzure
# Description: Disconnect from Azure ARM
# ------------------------------------------------
Function Disconnect-AaAzure {
    Disconnect-AzAccount

    # Check if connected to Azure
    $context = Get-AzContext
    if ($null -eq $context) {
        Write-Host "** Disconnected from Azure."
    }
    else {
        Write-Host "** Still connected to Azure."
        Write-Host "Azure Context Name: $($context.Name)"
    } 
}

# ------------------------------------------------
# Function: Is-AaMemberTypeValid
# Description: Check and see if member type is in the list ("user", "servicePrincipal", "group")
# ------------------------------------------------
Function Is-AaMemberTypeValid {
    param (
        [parameter(Mandatory)]
        [string]$MemberType,
        [parameter(Mandatory = $False)]
        $MemberTypes = @("user", "servicePrincipal", "group")
    )
    
    if ($MemberTypes -contains $MemberType) {
        return $True
    }

    throw "Member Type is not in $MemberTypes"
}

# ------------------------------------------------
# Function: Get-AaAzureADMemberType
# Description: Get the correct member type including zAccount
# ------------------------------------------------
Function Get-AaAzureADMemberType {
    param(
        [parameter(Mandatory)]
        [object] $Member
    )

    $memberType = $Member.OdataType.Substring(17)
    
    # Validate member type
    $validType = Is-AaMemberTypeValid $memberType

    # Must check 'user', because regular service principal's job title also empty
    if ((($memberType -eq "user")) -and ($Member.JobTitle.Length -eq 0)) {
        $memberType = "zAccount"
    }

    return $memberType
}

# ------------------------------------------------
# Function: Get-AaAzureADGroupMember
# Description: Recursive call to get all members 
#   including nested groups' members.
#   If the AAD group contains no members, the Function
#   will throw an exception. 
# ------------------------------------------------
Function Get-AaAzureADGroupMember {
    param(
        [parameter(Mandatory)]
        [string]$AADGroupID,
        [parameter(Mandatory = $False)]
        [string]$AADGroupName,
        [parameter(Mandatory = $False)]
        [List[PSCustomObject]]$Members = [List[PSCustomObject]]::new()
    )
    # Get-AzADGroupMember: Preview feature generates a lot of warning message, we want to ignore them
    $aadGroupMembers = Get-AzADGroupMember -ObjectId $AADGroupID -WarningAction Ignore -ErrorAction Ignore

    # if AAD group not found or AAD group has no members
    if ($null -eq $aadGroupMembers) {
        $errorMessage = "AAD group [$AADGroupID] members can't be found"
        throw $errorMessage
    }

    if ($AADContOwners) {
        Get-AaAzureGroupOwnerList -AADGroupID $AADGroupID
    }

    foreach ($member in $aadGroupMembers) {
        $memberType = Get-AaAzureADMemberType $member
        
        $r = [ordered]@{
            "AADGroupName" = $AADGroupName          
            "DisplayName"  = $member.DisplayName
            "EMail"        = $member.Mail
            "GivenName"    = $member.GivenName
            "Surname"      = $member.Surname
            "JobTitle"     = $member.JobTitle
            "Id"           = $member.Id
            "Department"   = $member.Department
            "AAEmployId"   = $member.MailNickname
            "MemberType"   = $memberType    
        }
        $Members.Add([PSCustomObject]$r)

        if ("group" -ieq $memberType) {
            # Recursive call to find out nested groups and members
 
            return (Get-AaAzureADGroupMember -AADGroupID $member.Id `
                    -AADGroupName $member.DisplayName -Members $Members)
        }


    }

    return $Members
}

# ------------------------------------------------
# Function: Check-AaAzureADGroupContainsSP
# Description: If the AAD group contains no members, 
#   the Function will return an error message. 
# ------------------------------------------------
Function Check-AaAzureADGroupContainsSP {
    param(
        [parameter(Mandatory = $True)]
        [string]$AADGroupID
    )
    
    $result = [PSCustomObject]@{
        "SPAccount"    = $false
        "ZAccount"     = $false
        "ErrorMessage" = ""
    }

    $aadGroupMembers = Get-AzADGroupMember -ObjectId $AADGroupID -WarningAction Ignore -ErrorAction Ignore
    # If AAD group not found or AAD group has no members
    if ($null -eq $aadGroupMembers) {
        $result.ErrorMessage = "AAD group [$AADGroupID] can't be found"
        return $result
    }
    
    foreach ($member in $aadGroupMembers) {
        $memberType = Get-AaAzureADMemberType $member
        if ("servicePrincipal" -eq $memberType) {
            $result.SPAccount = $true
            break
        }
        elseif ("zAccount" -eq $memberType) {
            $result.ZAccount = $true
            break
        }
        elseif ("group" -eq $memberType) {
            return (Check-AaAzureADGroupContainsSP -AADGroupID $member.Id)
        }
    }
    return $result
}

# ------------------------------------------------
# Function: Is-AaAzureAssignedRoleInScope
# Description: Check both Role and Scope to ensure 
#   the desired role is found in the desired scope.
# ------------------------------------------------
Function Is-AaAzureAssignedRoleInScope {
    param(
        [parameter(Mandatory)]
        $RoleAssignment,
        [parameter(Mandatory)]
        [string] $DefaultScope,
        [parameter(Mandatory = $False)]
        [string] $DefaultRole = "Contributor"
    )

    # Check Contributor role here [Contributor, Contributor]
    $matchContributor = $False
    if ($RoleAssignment.RoleDefinitionName.GetType() -eq "string") {
        if ($RoleAssignment.RoleDefinitionName -eq $DefaultRole) {
            $matchContributor = $True
        }
    }
    else {
        # RoleDefinitionName is an object[]
        foreach ($r in $RoleAssignment.RoleDefinitionName) {
            if ($r -eq $DefaultRole) {
                $matchContributor = $True
                break
            }            
        }
    }

    # Check if the Role Assignment contains right Scope
    if ($matchContributor) {
        Write-Host "Contributor found, compare Scope..."
        Write-Host "RoleAssignment.Scope: $($RoleAssignment.Scope)"
        Write-Host "DefaultScope: $DefaultScope"
        
        if ($RoleAssignment.Scope.GetType() -eq "string") {
            if ($RoleAssignment.Scope -eq $DefaultScope) {
                Write-Host "In the same scope, $DefaultRole role assignment to be removed"
                return $True
            }
        }
        else {
            # Scope is an object[]
            foreach ($s in $RoleAssignment.Scope) {
                if ($s -eq $DefaultScope) {
                    Write-Host "In the same scope, $DefaultRole role assignment to be removed"
                    return $True
                }
            }
        }
    }

    Write-Host "Different scopes, $DefaultRole role assignment not to be removed"

    return $False
}

# ------------------------------------------------
# Function: Process-AaSonraiCSV
# Description: Use input from Sonrai query CSV, return a unique list.
# ------------------------------------------------
Function Process-AaSonraiCSV {

    param (
        [parameter(Mandatory)]
        [Object] $CsvData
    )

    $rowCount = 0
    $scopeSet = [HashSet[string]]::new()
    $results = [List[PSCustomObject]]::new()
    $aadGroups = [List[PSCustomObject]]::new()
    $subSet = [List[PSCustomObject]]::new()

    # Loop through each entry in the CSV file
    foreach ($row in $CsvData) {
        $rowCount ++
        # Get all columns from CSV
        $subscriptionName = $row."Subscription Name"
        $resourceGroup = $row."Resource Group Name"
        $policyScope = $row."Policy Scope"
        $subscriptionId = ($policyScope -split '/')[2]
        if ($null -eq $resourceGroup) {
            $resourceGroup = ($policyScope -split '/')[4]
        }
        # Original Policy Scope from Sonrai Query contains more sub-scopes
        # We just need 'resource group' scope only.
        $scope = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
        $aadGroupName = $row."Resource Name"
        $aadGroupId = $row."Resource Group ID"
        $userObjectId = $row."Identity Principal ID"
        $userAAId = $row."Identity AAID"
        $userName = $row."Identity Name"
        $userEmail = $row."Identity Email"
        $userCorpAAEmail = -join ($row."Identity AAID", "@corpaa.aa.com")
        $managerName = $row."Identity Manager"
        $managerEmail = $row."Identity Manager Email"

        # Remove duplicate (scope + aadgroup)
        $key = -join ($scope, "-", $aadGroupId)
        $addSuccess = $scopeSet.Add($key)



        if ($addSuccess) {
  
            # Create a hashtable to store the result
            $result = [ordered]@{
                "AADGroupName"      = $aadGroupName
                "AADGroupID"        = $aadGroupId
                "SubscriptionID"    = $subscriptionId
                "SubscriptionName"  = $subscriptionName
                "ResourceGroupName" = $resourceGroup
                "SPAccount"         = $false
                "ZAccount"          = $false
                "Scope"             = $scope
                "Status"            = ""
                "Roles"             = ""
            }      
                 
            try {
                if ($RGAADOwners) { 
                    #process to get the RG owners
                    Get-RGOwnerDetail -Scope $scope
                }

                # Process AAD group and its members
                $GroupMembers = Get-AaAzureADGroupMember -AADGroupID $aadGroupId `
                    -AADGroupName $aadGroupName
                $aadGroups.Add($GroupMembers)

                #de-dup of the subscriptions
                if ($SubOwners) {
                    if (-not $subSet.Contains($subscriptionId)) {
                        if ($subscriptionId -ne $null) {
                            $subSet.Add($subscriptionId)
                        }
                    }
                } 

            }
            catch {
                $errorMessage = $_.Exception.Message
                Write-Host $errorMessage
                # $result.Status = $errorMessage
            }

            # Detect SP
            $FindAADGroupSPZAccount = Check-AaAzureADGroupContainsSP -AADGroupID $aadGroupId
            # Check exception for AAD group
            if ("" -ne $FindAADGroupSPZAccount.ErrorMessage) {
                $result.Status = $FindAADGroupSPZAccount.ErrorMessage
                Write-Host $FindAADGroupSPZAccount.ErrorMessage
            }
            else {
                # No error, check if it contains SP, Z-Account
                $result.SPAccount = $FindAADGroupSPZAccount.SPAccount
                $result.ZAccount = $FindAADGroupSPZAccount.ZAccount
            }
            $results.Add([PSCustomObject]$result)  
                    

        }   
    }

    if ($SubOwners) {
        #process to get the SUB owners
       
        write-host $scriptDir\
        . $scriptDir\Subscription-owner-list.ps1
        Get-SubOwnerDetail  -SubId $subSet 
    }

    return $results, $rowCount, $aadGroups
}

# ------------------------------------------------
# Function: Remove-AaAzureRoleAssignment
# Description: Remove role assignment, default role: Contributor
# ------------------------------------------------
Function Remove-AaAzureRoleAssignment {
    param (
        [parameter(Mandatory)]
        [string]$Principal,
        [parameter(Mandatory)]
        [string]$Scope,
        [parameter(Mandatory)]
        [bool]$SPAccount,
        [parameter(Mandatory)]
        [bool]$ZAccount,
        [parameter(Mandatory = $False)]
        [switch]$WetRun,
        [parameter(Mandatory = $False)]
        [string]$Role = "Contributor"
    )

    $r = [ordered]@{
        "Principal" = $Principal
        "Scope"     = $Scope
        "Role"      = $Role
        "Status"    = $null
        "Roles"     = ""
    }

    $subscriptionId = ($Scope -split '/')[2]


    # Get the role assignment
    try {
        # Switch to current active subscription
        Set-AzContext -Subscription $subscriptionId
        $roleAssignment = Get-AzRoleAssignment -RoleDefinitionName $Role -ObjectId $Principal -Scope $Scope -ErrorAction Stop
   
        # Check if the role assignment exists
        if ($null -eq $roleAssignment) {
            Write-Host "** [No Action] No matching role assignment in Azure for AAD-Group-ID: $Principal at Scope: $Scope"
            $r.Status = "No Action: $Role role is not found in given Scope."
            return $r
        }

        # Check if a Contributor role is found in the exact scope
        $foundContributor = Is-AaAzureAssignedRoleInScope -RoleAssignment $roleAssignment -DefaultScope $Scope

        # Set roles for report only
        $r.Roles = $roleAssignment.RoleDefinitionName
        if ($r.Roles.GetType().Name -eq "Object[]") {
            $r.Roles = $r.Roles -join ","
        }
        # Log 'Role' to be removed
        Write-Host "** Role-Assignment => [$($r.Roles)] - $foundContributor"

        if ($foundContributor) {
            try {
                if ($SPAccount) {
                    Write-Host "*** [Remediation] AAD Group contains Service Principal. $Role access not removed"
                    $r.Status = "Remediation: AAD Group contains Service Principal. $Role access not removed"
                }
                elseif ($ZAccount) {
                    Write-Host "*** [Remediation] AAD Group contains Z-Account. $Role access not removed"
                    $r.Status = "Remediation: AAD Group contains Z-Account. $Role access not removed"
                }
                else {
                    # Revoke logic below
                    # Wet Run
                    if ($WetRun) {
                        Remove-AzRoleAssignment -ObjectId $Principal -RoleDefinitionName $Role -Scope $Scope -ErrorAction Stop
                        Write-Host "*** [Success] Revoked $Role Role for AAD-Group-ID: $Principal, AAD-Group: $aadGroupName at Scope: $Scope"
                        $r.Status = "Success: Contributor Access was Removed."
                    }
                    else {
                        # Dry Run
                        Write-Host "*** [Dry run] Revoked $Role Role for AAD-Group-ID: $Principal, AAD-Group: $aadGroupName at Scope: $Scope"
                        $r.Status = "[Dry run] Success: Contributor Access TO-BE Removed."
                    }
                }
            }
            catch {
                $errorMessage = $_.Exception.Message
                Write-Host "**[Failed] An error occurred while removing the role assignment for AAD-Group-ID: $Principal at Scope: $Scope. Error: $errorMessage"
                # Write-Host $_.ScriptStackTrace
                $r.Status = "Failed: $errorMessage"
            }
        }
        else {
            Write-Host "*** [No Action] Privileged $Role role is not in the specified Scope."
            $r.Status = "No Action: Privileged $Role role is not found in the specified Scope."
        }

    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "**[Failed] to execute Get-AzRoleAssignment AAD-Group-ID: $Principal at Scope: $Scope. Error: $errorMessage"
        # Write-Host $_.ScriptStackTrace
        $r.Status = "Failed: $errorMessage"
    }

    return $r
}

Function Get-RGOwnerDetail {
    param (
        [parameter(Mandatory)]
        [string]$Scope,
        [parameter(Mandatory = $False)]
        [string]$Role = "Owner"
    )

    $RGOwners = Get-AzRoleAssignment -Scope $Scope -ErrorAction Stop | Where-Object { $_.RoleDefinitionName -eq $Role }
    foreach ($own in $RGOwners) {
        if ($own.ObjectType -eq 'Group') {
            Write-Host $own.ObjectId
            $GroupMembers = Get-AaAzureADGroupMember -AADGroupID $own.ObjectId `
                -AADGroupName $own.DisplayName
            foreach ($group in $GroupMembers) {
                foreach ($member in $group) {
                    $aadGroupOwners.Add($member)
                }
            }
        }
        elseif ($own.ObjectType -eq 'User') {
            $EmailId = (Get-AzADUser -ObjectId $own.ObjectId).Mail
            $r = [ordered]@{
                "ResGroupOwner" = $own.DisplayName
                "ResGroupName"  = $ResourceGroup
                "RGRole"        = $own.RoleDefinitionName
                "Email"         = $EmailId
            }
            $RgOwner.Add([PSCustomObject]$r)
        }            

    }

}

Function Get-AaAzureGroupOwnerList {
    param (
        [parameter(Mandatory)]
        [string]$AADGroupID
    )
    $aadGroupOwner = Get-AzADGroupOwner -GroupId $AADGroupID -WarningAction Ignore -ErrorAction Ignore
    if ($null -eq $aadGroupOwner) {
        $errorMessage = "AAD group [$AADGroupID] Owner can't be found"
        throw $errorMessage
    }

    foreach ($own in $aadGroupOwner) {
        Write-Host "aad group owner" $own.Mail
        if ($own -ne $null) {
            $r = [ordered]@{
                "AADGroupOwnerEmail" = $own.Mail
                "AADGroupID"         = $AADGroupID
                "AADGroupName"       = $AADGroupName
            }
            $AADContOwnerList.Add([PSCustomObject]$r)

        }
    }

}

# ------------------------------------------------
# Main Program Flow
# ------------------------------------------------
Function Main {
    Write-Host "***=- Welcome to Remove-AaAzureContributorAccess -=***" -ForegroundColor DarkGreen -BackgroundColor White
    $VERSION = Get-AaDateTimeAsString

    # ------------------------------------------------
    # 1. Take arguments
    # ------------------------------------------------
    Write-Host "** Params: (Input: $InputFile, Wet-run: $WetRun)"

    # Input file from Sonrai
    $csvFile = $InputFile
    if (-Not ($csvFile -Match ".csv")) {
        throw "InputFile must be a csv file."
    }

    # csvData is an Object
    $csvData = Read-AaCSV -CsvFile $csvFile

    # Get report output file path
    $outPath = ($InputFile.SubString(0, $InputFile.Length - 4))
    $reportPath = -join ($outPath, "_OUT_", $VERSION, ".csv")

    Write-Host "** Input-Csv-File: $csvFile, Output-Path: $reportPath, Wet-Run: $WetRun)"

    # ------------------------------------------------
    # 2. Connect to Azure
    # ------------------------------------------------
    # Disconnect the current AzContext if any, and use SP by default
    # Optionally, can use -UserPrincipal switch
    if ($UserPrincipal) {
        Connect-AaAzure -UserPrincipal
    }
    else {
        Connect-AaAzure -Force
    }

    # ------------------------------------------------
    # 3. Process CSV
    # ------------------------------------------------
    $results, $rowCount, $aadGroups = Process-AaSonraiCSV -CsvData $csvData

    # ------------------------------------------------
    # 4. Process AAD Groups and Members
    # ------------------------------------------------
    $allMembers = [List[PSCustomObject]]::new()
    foreach ($group in $aadGroups) {
        foreach ($member in $group) {
            $allMembers.Add($member)
        }
    }
    # Output to a CSV file
    $allMembers | Export-Csv -Path ".\aad-groups-all-members-$VERSION.csv" -NoTypeInformation

    if ($RGAADOwners) {
        $RgOwner | Export-Csv -Path ".\res-grp-owners-$VERSION.csv" -NoTypeInformation
        $aadGroupOwners | Export-Csv -Path ".\aad-grp-owners-$VERSION.csv" -NoTypeInformation
    }
    if ($AADContOwners) {
        $AADContOwnerList | Export-Csv -Path ".\cont-owners-$VERSION.csv" -NoTypeInformation
    }

    # ------------------------------------------------
    # 5. Remove Contributor Role Assignment by default
    # ------------------------------------------------
    $count = 0
    foreach ($record in $results) {
        $count ++
        Write-Host "==> Record # $count"
        $res = $null
        # Real production run, must use '-WetRun' switch
        if ($WetRun) {
            $res = Remove-AaAzureRoleAssignment -Principal $record.AADGroupID -Scope $record.Scope `
                -SPAccount $record.SPAccount -ZAccount $record.ZAccount -WetRun
        }
        else {
            # Dry run by default
            $res = Remove-AaAzureRoleAssignment -Principal $record.AADGroupID -Scope $record.Scope `
                -SPAccount $record.SPAccount -ZAccount $record.ZAccount
        }
        $record.Status = $res.Status
        $record.Roles = $res.Roles
    }

    # ------------------------------------------------
    # 6. Print processing info
    # ------------------------------------------------
    Write-Host "** Total CSV Records Read: $rowCount" -ForegroundColor DarkGreen -BackgroundColor White
    Write-Host "** Total Processed Count: $($results.Count)" -ForegroundColor DarkGreen -BackgroundColor White

    # ------------------------------------------------
    # 7. Export CSV report
    # ------------------------------------------------
    $results | Export-Csv -Path $reportPath -NoTypeInformation
    Write-Host "** Output Report in $reportPath"

    # ------------------------------------------------
    # 8. Disconnect from Azure when the job is done
    # ------------------------------------------------
    Disconnect-AaAzure
}

# Run the Main function
Main
