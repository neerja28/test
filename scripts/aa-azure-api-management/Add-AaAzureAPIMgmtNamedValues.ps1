using namespace System.Collections.Generic

Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string] $InputFile,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch] $UserPrincipal,
    [Parameter(Mandatory = $False, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [bool]$DryRun = $true

)

Function Get-AaDateTimeAsString {
    return Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
}


# ------------------------------------------------
# Function: Read-apimgmtCSV
# Description: Read the CSV file and return an object
# ------------------------------------------------
Function Read-apimgmtCSV {
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


Function Update-AaApimCSV {

    param (
        [parameter(Mandatory)]
        [Object] $CsvData,
        [parameter(Mandatory)]
        [Object] $TargetNamedValues
    )    
    $resultNV = [List[PSCustomObject]]::new()
    $resultError = [List[PSCustomObject]]::new()
    $resultSuccess = [List[PSCustomObject]]::new()
    $resultNV = @()
    $resultError = @()
    $resultSuccess = @()

    $appshortName = $null
    $sub = $null

    foreach ($row in $CsvData) {
        $sub = $row."SubscriptionId"
        $SubscriptionName = $row."SubscriptionName"
        $resourceGroup = $row."ResourceGroup"
        $apimName = $row."ApimService"
        $apimValueName = $row."NamedValueName"
        $apimValue = $row."Value"
        $appshortName = $row."AppShortName"

        try {
            Write-Host "  → APIM: $apimName in RG: $resourceGroup AppShortName: $appshortName" -ForegroundColor Green

            if ($DryRun) {
                Write-Host " - DryRun Adding Named Value: $apimValueName" -ForegroundColor Yellow
                $resultNV += [PSCustomObject]@{
                    SubscriptionId   = $sub
                    SubscriptionName = $subscriptionName
                    ResourceGroup    = $resourceGroup
                    ApimService      = $apimName
                    NamedValueName   = if ($apimValueName) { $apimValueName } else { $null }
                    Value            = if ($apimValue) { $apimValue } else { $null }
                    AppShortName     = if ($appshortName) { $appshortName } else { $null }
                    Timestamp        = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                }

            }
            else {
                try {
                    # Add the named value
                    $contextApim = New-AzApiManagementContext -ResourceGroupName $resourceGroup -ServiceName $apimName

                    New-AzApiManagementNamedValue `
                        -Context $contextApim `
                        -NamedValueId $apimValueName `
                        -Name $apimValueName `
                        -Value $apimValue `

                    Write-Host "  → Successfully Added APIM Named value: $apimValueName in RG: $resourceGroup for Serivce $apimName" -ForegroundColor Green
                        
                    $resultSuccess += [PSCustomObject]@{
                        SubscriptionId   = $sub
                        SubscriptionName = $subscriptionName
                        ResourceGroup    = $resourceGroup
                        ApimService      = $apimName
                        NamedValueName   = if ($apimValueName) { $apiValueName } else { $null }
                        Value            = if ($apimValue) { $apiValue } else { $null }
                        AppShortName     = if ($appshortName) { $appshortName } else { $null }
                        AddedTimestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    }

                }
                catch {
                    Write-Host "Error adding Named value for $apimName. Error: $($_.Exception.Message)"
                }
 

            }

           
        }
        catch {
            Write-Error "Failed to create Named Value for  rg $resourceGroup, apim $apimName  Error: $_"
            $resultError += [PSCustomObject]@{
                NAME             = $apimName
                SUBSCRIPTION     = $subscriptionName
                "RESOURCE GROUP" = $resourceGroup
                ERROR            = "Error getting the details for $apimName. Error: $($_.Exception.Message)"
            }

            
        }
        
    }

    return [PSCustomObject]@{
        DryRunNames = $resultNV
        Errors              = $resultError
        AddNamed        = $resultSuccess
    }
}

# ------------------------------------------------
# Main Program Flow
# ------------------------------------------------
Function Main {
    Write-Host "***=- Welcome to Add-AaAzureAPIMgmtNamedValues -=***" -ForegroundColor DarkGreen -BackgroundColor White
    $VERSION = Get-AaDateTimeAsString
    $results = [List[PSCustomObject]]::new()
    $resultNV = [List[PSCustomObject]]::new()
    $resultError = [List[PSCustomObject]]::new()
    $resultSuccess = [List[PSCustomObject]]::new()


    # ------------------------------------------------
    # 1. Take arguments
    # ------------------------------------------------
    Write-Host "** Params: (Input: $InputFile)"

    # Input file from azure portal
    $csvFile = $InputFile
    if (-Not ($csvFile -Match ".csv")) {
        throw "InputFile must be a csv file."
    }
  
    # csvData is an Object
    $csvData = Read-AaCSV -CsvFile $csvFile

  
    # Get report output file path
    $outPath = ($InputFile.SubString(0, $InputFile.Length - 4))
    $reportPath = -join ($outPath, "_ADD_OUT_", $VERSION, ".csv")   
    $errorReportPath = -join ($outPath, "_ADD_OUT_ERROR_", $VERSION, ".csv")
    $addReportpath = -join ($outPath, "_ADD_OUT_SUCCESS_", $VERSION, ".csv")

    Write-Host "** Input-Csv-File: $csvFile, Output-Path: $reportPath)"
    Write-Host "** Error-Report-Csv-File: $csvFile, Output-Path: $errorReportPath)"


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
  

    #Get the SALT tool named values
    $namedValuesFile = ".\salt-remove-apim-list.txt"
    $targetNamedValues = Get-Content -Path $namedValuesFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }


    # ------------------------------------------------
    # 3. Process CSV
    # ------------------------------------------------

    $resultsObj = Update-AaApimCSV -CsvData $csvData -TargetNamedValues $targetNamedValues

    $resultNV = @($resultsObj.DryRunNames)
    $resultError = @($resultsObj.Errors)
    $resultSuccess = @($resultsObj.AddNamed)

    $results = @($results) ?? @()

    if ($resultNV -and $resultNV.Count -gt 0) { $results += $resultNV }


    # Export results to CSV
    if ($results -and $results.Count -gt 0) {
        $results | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
        Write-Host "Finished! Output saved to $reportPath" -ForegroundColor Yellow
    }

    # Export resultError results to CSV
    if ($resultError -and $resultError.Count -gt 0) {
        $resultError | Export-Csv -Path $errorReportPath -NoTypeInformation -Encoding UTF8
        Write-Host "Finished! Output saved to $errorReportPath" -ForegroundColor Yellow
    } 
    

    # Export remove results to CSV
    if ($resultSuccess -and $resultSuccess.Count -gt 0) {
        $resultSuccess | Export-Csv -Path $addReportpath -NoTypeInformation -Encoding UTF8
        Write-Host "Finished! Output saved to $addReportpath" -ForegroundColor Yellow
    } 

    # Disconnect Azure
    Disconnect-AaAzure

}

# Run the Main function
Main

