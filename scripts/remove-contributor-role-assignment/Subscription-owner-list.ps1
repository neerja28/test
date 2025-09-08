using namespace System.Collections.Generic

Function Get-SubOwnerDetail {
    param (
        [parameter(Mandatory=$False)]
        [string]$Role = "Owner",
        [parameter(Mandatory)]
        [Object] $SubIds
    )
    [List[PSCustomObject]]$SubOwner = [List[PSCustomObject]]::new()

    # Loop through all subscriptions
    foreach ($subId in $SubIds) {
        Write-Host "getting subs"
        Write-Host $subId

        # Get role assignments for 'Owner' role within the subscription scope
        try{

            $subScope = "/subscriptions/" + $subId
            $roleAssignments = Get-AzRoleAssignment -Scope $subScope -ErrorAction Stop | Where-Object { $_.RoleDefinitionName -eq $Role } -WarningAction Ignore -ErrorAction SilentlyContinue
    
            # Process each role assignment
            foreach ($roleAssignment in $roleAssignments) {

                if ($roleAssignment.ObjectType -eq 'Group') {

                    # If the object is a group, get its members
                    $groupMembers = Get-AzADGroupOwner -GroupId $roleAssignment.ObjectId -WarningAction Ignore -ErrorAction SilentlyContinue
                        foreach ($member in $groupMembers) {
                        # Add each group member to the export data list

                        $emailID = if ($member.ObjectType -eq 'User') {
                            (Get-AzADUser -ObjectId $member.Id).Mail
                            Write-Host "group member $emailID"
                        } else {
                            $null
                        }
                        $data = @{
                            SubscriptionName = $subScope
                            RoleType = "Group"
                            GroupOrUserName = $roleAssignment.DisplayName
                            MemberName = $member.DisplayName
                            MemberEmail = $emailID
                        }
                        $SubOwner.Add([PSCustomObject]$data)
                    }
                } elseif ($roleAssignment.ObjectType -eq 'User') {
                    # If the object is a user, capture the user's details
                    $user = Get-AzADUser -ObjectId $roleAssignment.ObjectId
                    $data = @{
                        SubscriptionName = $subScope
                        RoleType = "User"
                        GroupOrUserName = $roleAssignment.DisplayName
                        MemberName = $user.DisplayName
                        MemberEmail = $user.Mail
                    }
                    $SubOwner.Add([PSCustomObject]$data)
                }
            }
        }catch{
            Write-Host "An error occurred while getting the role assignment for subscription: $subId. Error: $errorMessage"

        }
  
    }

    
    #process to get the SUB owners
    $SubOwner | Export-Csv -Path ".\sub-owners-$VERSION.csv" -NoTypeInformation
}