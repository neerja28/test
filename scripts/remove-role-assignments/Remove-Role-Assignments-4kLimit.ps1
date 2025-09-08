using namespace System.Collections.Generic

Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $InputFile,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $UserPrincipal,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [bool]$DryRun = $true,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [bool]$ResourceGroupScope = $false

)

Function Get-AaDateTimeAsString {
    return Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
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

Function Read-4kLimitCSV {
    param (
        [Parameter(Mandatory)]
        [string]$CsvFile
    )

    # Read the CSV file
    Write-Host "** Reading CSV file... $CsvFile"
    $csvData = Import-Csv -Path $CsvFile

    if ($csvData[0].PSObject.Properties.Name -contains 'Status') {
        # Check if any row in Status column contains 'dry run' (case-insensitive)
        $hasDryRun = $csvData | Where-Object { $_.Status -match 'dry\s*run' }
        if(-not $hasDryRun) {
            Write-Host "The CSV file does not contain any 'dry run' entries in the Status column." -ForegroundColor Yellow
            return
        }
    }
     

    # Check if CSV file is read correctly
    if ($null -eq $csvData) {
        Write-Host "Failed to read CSV file."
        return
    }
    Write-Host "** CSV file read successfully."

    return $csvData
}


Function Update-roleAssignmentCSV {

    param (
        [parameter(Mandatory)]
        [Object] $CsvData,
        [parameter(Mandatory)]
        [string] $CsvFile
    )    


    $resultObjRg = [List[PSCustomObject]]::new()
    $resultObjRg = @()

    $resultObjSub = [List[PSCustomObject]]::new()
    $resultObjSub = @()

    $resultSuccess = [List[PSCustomObject]]::new()
    $resultSuccess = @()

    $resultDryRun = [List[PSCustomObject]]::new()
    $resultDryRun = @()

    $resultSkip = [List[PSCustomObject]]::new()
    $resultSkip = @()

    $resultError = [List[PSCustomObject]]::new()
    $resultError = @()

    $resultError1 = [List[PSCustomObject]]::new()
    $resultError1 = @()

    $resultSkip1 = [List[PSCustomObject]]::new()
    $resultSkip1 = @()

    $resultFinal = [List[PSCustomObject]]::new()
    $resultFinal = @()

    $roleNameList = ".\role-assignment-list.txt"
    $targetRoleValues = Get-Content -Path $roleNameList | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

    $exclusionList = ".\object-type-exclusion-list.txt"
    $exclusionListValues = Get-Content -Path $exclusionList | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

    $resGrpList = ".\resourcegrp-list.txt"
    $resGrpListValues = Get-Content -Path $resGrpList | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

    $funAcctList = ".\acct-type-exclusion-list.txt"
    $targetFunAcctValues = Get-Content -Path $funAcctList | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }


    $filterRoleList = $targetRoleValues | Where-Object {
        $_.Trim() -and -not $_.Trim().StartsWith("#")
    }

    $filterPrincipalTypeList = $exclusionListValues | Where-Object {
        $_.Trim() -and -not $_.Trim().StartsWith("#")
    }

    $filterResGrpList = $resGrpListValues | Where-Object {
        $_.Trim() -and -not $_.Trim().StartsWith("#")
    }

    $filterFunAcctList = $targetFunAcctValues | Where-Object {
        $_.Trim() -and -not $_.Trim().StartsWith("#")
    }
 

    foreach ($row in $CsvData) {
        $scopeId = $row."id"
        # $roleAssignmentId = $row."role_definition_id"
        $roleAssignmentName = $row."role_name"
        $principalId = $row."principal_id"
        $principalType = $row."principal_type"
        $principalName = $row."principal_display_name"

        try {
            #get sub id
            $subscriptionId = ($scopeId -split "/")[2]
            $scope = $scopeId -split "/providers/" | Select-Object -First 1

            Write-host "scope is $scope"
            
            # Change the active subscription
            Write-Host "Changing active subscription to: $subscriptionId"
            Set-AzContext -SubscriptionId $subscriptionId

            if ($ResourceGroupScope) {
                $resGrpMatch = $filterResGrpList | Where-Object { $scope -match "/resourcegroups/$_($|/)" }
                if (-not $resGrpMatch) {
                    Write-Host "→ Skipping scope $scope as it does not match any resource group in the filter list." -ForegroundColor Yellow
                    $resultSkip1 += [PSCustomObject]@{
                        id                     = $scopeId
                        role_name              = $roleAssignmentName
                        principal_id           = $principalId
                        principal_type         = $principalType
                        principal_display_name = $principalName
                        Error                  = 'null'
                        Timestamp              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                        Status                 = 'skipped - not in the RG list ' + ' for scope ' + $scope
                    }
                }
                else {
                    Write-Host "→ Found RG  $resGrpMatch match from the filter list for the scope $scope "
                    $resultObjRg += Remove-RoleAssignments `
                        -Scope $scope `
                        -RoleAssignment $roleAssignmentName `
                        -PrincipalId $principalId `
                        -PrincipalType $principalType `
                        -FilterRoleList $filterRoleList `
                        -FilterPrincipalTypeList $filterPrincipalTypeList `
                        -DryRun $DryRun `
                        -FilterFunAcctList $filterFunAcctList `
                        -PrincipalName $principalName `
                        -ScopeId $scopeId `
                        -resultDryRun $resultDryRun `
                        -ResultSuccess $resultSuccess `
                        -ResultSkip $resultSkip `
                        -ResultError $resultError
                }

            }
            else {
                #remove all at subscription level
                Write-Host "→ Revoke role assignment from the Subscription scope $scope " -ForegroundColor Green
                $resultObjSub += Remove-RoleAssignments `
                    -Scope $scope `
                    -RoleAssignment $roleAssignmentName `
                    -PrincipalId $principalId `
                    -PrincipalType $principalType `
                    -FilterRoleList $filterRoleList `
                    -FilterPrincipalTypeList $filterPrincipalTypeList `
                    -DryRun $DryRun `
                    -FilterFunAcctList $filterFunAcctList `
                    -PrincipalName $principalName `
                    -ScopeId $scopeId `
                    -resultDryRun $resultresultDryRun `
                    -ResultSuccess $resultSuccess `
                    -ResultSkip $resultSkip `
                    -ResultError $resultError
            }
 
        }
        catch {
            Write-Host "An error occurred while setting Set-AzContext for the role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
            $errorMessage = $_.Exception.Message
            $resultError1 += [PSCustomObject]@{
                id                     = $scopeId
                role_name              = $roleAssignmentName
                principal_id           = $principalId
                principal_type         = $principalType
                principal_display_name = $principalName
                Error                  = $errorMessage
                Timestamp              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                Status                 = 'failed to set context for role assignment'
            }
        }

        
    }

    if ($resultObjRg -and $resultObjRg.Count -gt 0) {
        Write-Host "Found $($resultObjRg.Count) role assignments at Resource Group scope."
        $resultError1 += @($resultObjRg.roleAssignmentError) ?? @()
        $resultFinal += @($resultObjRg.roleAssignmentDryRun) ?? @()
        $resultFinal += @($resultObjRg.roleAssignmentSuccess) ?? @()
        $resultSkip1 += @($resultObjRg.roleAssignmentSkip) ?? @()
    }
    elseif ($resultObjSub -and $resultObjSub.Count -gt 0) {
        Write-Host "Found $($resultObjSub.Count) role assignments at Subscription scope."
        $resultError1 += @($resultObjSub.roleAssignmentError) ?? @()
        $resultFinal += @($resultObjSub.roleAssignmentDryRun) ?? @()
        $resultFinal += @($resultObjSub.roleAssignmentSuccess) ?? @()
        $resultSkip1 += @($resultObjSub.roleAssignmentSkip) ?? @()
    }


    if ($resultObjRg.roleAssignmentSuccess -and ($resultObjRg.roleAssignmentSuccess.Count -gt 0 ) ) {
        #write to file
        $outPath = ($InputFile.SubString(0, $CsvFile.Length - 4))
        $successPath = -join ($outPath, "_OUT_SUCCESS_RG", ".csv")  
        $resultObjRg.roleAssignmentSuccess | Export-Csv -Path $successPath -NoType
    }
    elseif ($resultObjSub.roleAssignmentSuccess -and ($resultObjSub.roleAssignmentSuccess.Count -gt 0)) {
        #write to file
        $outPath = ($InputFile.SubString(0, $CsvFile.Length - 4))
        $successPath = -join ($outPath, "_OUT_SUCCESS_SUB", ".csv")  
        $resultObjSub.roleAssignmentSuccess | Export-Csv -Path $successPath -NoType
    }

    return [PSCustomObject]@{
        roleAssignments     = $resultFinal
        roleAssignmentSkip  = $resultSkip1
        roleAssignmentError = $resultError1
    }

}

Function Remove-RoleAssignments {
    param (
        [string] $scope,
        [string] $roleAssignmentName,
        [string] $principalId, 
        [string] $principalType,
        [List[string]] $filterRoleList,
        [List[string]] $filterPrincipalTypeList,
        [bool] $DryRun,
        [List[string]] $filterFunAcctList,
        [string] $principalName,
        [string] $scopeId,
        [List[PSCustomObject]] $resultDryRun,
        [List[PSCustomObject]] $resultSuccess,
        [List[PSCustomObject]] $resultSkip,
        [List[PSCustomObject]] $resultError

    )

    if ($filterRoleList -contains $roleAssignmentName) {
        if ($filterPrincipalTypeList -notcontains $principalType) {
            if (-not ($filterFunAcctList | Where-Object { $principalName -match $_ })) {
                Write-Host " → Revoking $roleAssignment role for PrincipalId: $principalId at Scope: $scope of Type: $principalType" -ForegroundColor Green
                if ($DryRun) {
                    Write-Host "***Dry-run**** Revoked $roleAssignment role for PrincipalId: $principalId at Scope: $scope"
                    $resultDryRun += [PSCustomObject]@{
                        id                     = $scopeId
                        role_name              = $roleAssignmentName
                        principal_id           = $principalId
                        principal_type         = $principalType
                        principal_display_name = $principalName
                        Error                  = 'null'
                        Timestamp              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                        Status                 = '***dry run*** ' + $roleAssignmentName + ' role revoked'
                    }
                }
                else {
                    try {
                        Remove-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName $roleAssignmentName -Scope $scope -ErrorAction Stop
                        Write-Host "Successfully revoked $roleAssignmentName role for PrincipalId: $principalId at Scope: $scope" -ForegroundColor Green
                        $resultSuccess += [PSCustomObject]@{
                            id                     = $scopeId
                            role_name              = $roleAssignmentName
                            principal_id           = $principalId
                            principal_type         = $principalType
                            principal_display_name = $principalName
                            Error                  = "null"
                            Timestamp              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                            Status                 = $roleAssignmentName + " role revoked"
                        }
                    }
                    catch [System.Management.Automation.ActionPreferenceStopException] {
                        $errorMessage = $_.Exception.Message
                        Write-Host "Failed to revoke $roleAssignmentName role for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                        $resultError += [PSCustomObject]@{
                            id                     = $scopeId
                            role_name              = $roleAssignmentName
                            principal_id           = $principalId
                            principal_type         = $principalType
                            principal_display_name = $principalName
                            Error                  = $errorMessage
                            Timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                            Status                 = 'failed to remove role assignment'
                        }
                    }
                    catch {
                        Write-Host "An error occurred while removing the role assignment for PrincipalId: $principalId at Scope: $scope. Error: $errorMessage"
                        $errorMessage = $_.Exception.Message
                        $resultError += [PSCustomObject]@{
                            id                     = $scopeId
                            role_name              = $roleAssignmentName
                            principal_id           = $principalId
                            principal_type         = $principalType
                            principal_display_name = $principalName
                            Error                  = $errorMessage
                            Timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                            Status                 = 'failed to remove role assignment'
                        }

                    }

                }
            }
            else {
                Write-Host " → Skipping $roleAssignmentName role for Functional or user Account: $principalName at Scope: $scope of Type: $principalType" -ForegroundColor Blue
                $resultSkip += [PSCustomObject]@{
                    id                     = $scopeId
                    role_name              = $roleAssignmentName
                    principal_id           = $principalId
                    principal_type         = $principalType
                    principal_display_name = $principalName
                    Error                  = 'null'
                    Timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    Status                 = 'skipped - functional account type excluded'
                }
            }
        }
        else {
            Write-Host " → Skipping $roleAssignmentName role for principal: $principalId at Scope: $scope of Type: $principalType" -ForegroundColor Yellow
            $resultSkip += [PSCustomObject]@{
                id                     = $scopeId
                role_name              = $roleAssignmentName
                principal_id           = $principalId
                principal_type         = $principalType
                principal_display_name = $principalName
                Error                  = 'null'
                Timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                Status                 = 'skipped - principal type not in target list'
            }
        }
    }
    else {
        Write-Host " → Skipping $roleAssignmentName role for PrincipalId: $principalId at Scope: $scope of Type: $principalType" -ForegroundColor Yellow
        $resultSkip += [PSCustomObject]@{
            id                     = $scopeId
            role_name              = $roleAssignmentName
            principal_id           = $principalId
            principal_type         = $principalType
            principal_display_name = $principalName
            Error                  = 'null'
            Timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Status                 = 'skipped - role not in target list'
        }
    }


    return [PSCustomObject]@{
        roleAssignmentDryRun  = $resultDryRun
        roleAssignmentSkip    = $resultSkip
        roleAssignmentSuccess = $resultSuccess
        roleAssignmentError   = $resultError
    }
}

# ------------------------------------------------
# Main Program Flow
# ------------------------------------------------
Function Main {
    Write-Host "***=- Welcome to Remove-Role-Assignments-4kLimit -=***" -ForegroundColor DarkGreen -BackgroundColor White
    $VERSION = Get-AaDateTimeAsString
    $results = [List[PSCustomObject]]::new()
    $results = @()
    # ------------------------------------------------
    # 1. Take arguments
    # ------------------------------------------------
    Write-Host "** Params: (Input: $InputFile)"

    # Input file from azure portal
    $csvFile = $InputFile
    if (-Not ($csvFile -Match ".csv")) {
        throw "InputFile must be a csv file."
    }

    if ($DryRun -eq $false -and -Not ($csvFile -Match "DryRun")) {
        throw "Input file $csvFile provided did not have DryRun result. Please provide a file with DryRun changes."
    }
  
    # csvData is an Object
    $csvData = Read-4kLimitCSV -CsvFile $csvFile

  
    # Get report output file path
    $outPath = ($InputFile.SubString(0, $InputFile.Length - 4))
    if ($DryRun) {
        $reportPath = -join ($outPath, "_DryRun", ".csv")  
    }
    else {
        $reportPath = -join ($outPath, "_OUT_", $VERSION, ".csv")  
    } 

    Write-Host "** Input-Csv-File: $csvFile, Output-Path: $reportPath)"

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

    $resultsObj = Update-roleAssignmentCSV -CsvData $csvData $csvFile
    if ($null -eq $resultsObj) {
        Write-Host "No results found."
    }
    $results = @($results) ?? @()
    
    $results += @($resultsObj.roleAssignments) ?? @()
    $results += @($resultsObj.roleAssignmentSkip) ?? @()        
    $results += @($resultsObj.roleAssignmentError) ?? @()

    # Export results to CSV
    if ($results -and $results.Count -gt 0) {
        $results | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
        Write-Host "Finished! Output saved to $reportPath" -ForegroundColor Yellow
    }
 
    # Disconnect Azure
    Disconnect-AaAzure

}

# Run the Main function
Main
