# Azure RBAC Assignment Limits

Azure role-based access control (RBAC) has a maximum limit of 4,000 role assignments per subscription. This limit applies across all scopes within the subscription: resource, resource group, and subscription levels. It does not include assignments at the management group level. Additionally, eligible role assignments and scheduled future assignments do not count toward this limit.

This 4,000-role assignment cap is fixed and cannot be increased. To stay within this limit, it's important to proactively monitor and reduce unnecessary role assignments.

# Troubleshooting RBAC Limit Issues

The following Python script allows you to:

- Retrieve all role assignments within a subscription
- Resolve user/group/service principal names from Microsoft Graph
- Classify assignments by **subscription** and **resource group** scopes
- Export results to an Excel spreadsheet for further analysis
- Identify stale or redundant role assignments

## Prerequisites to run the script

You need one or more of the following roles to successfully run the script and manage RBAC assignments:

- **Owner** – Full access, including RBAC permissions.
- **RBAC Administrator** – Ability to manage RBAC settings.
- **User Access Administrator** – Can assign/remove roles and delete custom roles.
- **Groups Administrator** or **User Administrator** – Can create and manage groups.
- **Reader** role to view all resources and the run Azure Resource Graph queries.

## How to Set Up and Use

Follow these steps to prepare and run the role assignment script:

### 1. Prepare Your Python Environment

```bash
python -m venv venv
source venv/bin/activate 
```

### 2. Install Required Packages

Create a ```requirements.txt``` file with the following content:

```
azure-identity
azure-mgmt-resource
azure-mgmt-authorization
azure-graphrbac
msgraph-core
psutil
requests
pandas
openpyxl
```

Then install the dependencies using:

```
pip install -r requirements.txt
```

### 3. Configure the Script

- Open a file named role_assignments.py.
- Replace the placeholder string ```subscription_id = "ADD_YOUR_SUBSCRIPTION_ID_HERE"``` in the script with your **Azure subscription ID.**

### 4. Run the Script

Execute the script using:

```
python role_assignments.py
```

The script will connect to Azure, fetch all role assignments, and export the data to an Excel file named:
```role_assignments.xlsx```

### Output

The output of the scipt is as follows

```
Role Assignment Breakdown for Subscription ID: xxxxx-xxxx-xxxx-xxxx-xxxxx
  Number of role assignments for this subscription : xxx
  At Subscription Level: xxx
  At Resource Group Level: xxx
Exported role assignment data to role_assignments.xlsx
```

# Optimization Recommendations

### 1. Orphaned Role Assignments (Low Hanging Fruit)

**Context**:

 When deleting Service Principal or Users from Entra ID role assignments need to be deleted as well. If not, they can linger.

**Action**:

- Identify and delete any role assignments with the principal name shown as `"Unknown"`.
- In the Azure Portal:
  - Look for `"Unknown"` under role assignments and delete role assignmnet.
- From the script's CSV output:
  - Filter the `principal_display_name` column for `"Unknown"` to locate stale entries.

### 2. Use AAD Groups for Role Consolidation

**Context**:

Role assignments for Owner, Contributor, and AA-Reader+ role assignments have a dedicated AAD Group already. Direct assignments to users or service principals should be replaced with group-based assignments to reduce count.

**Action**:

- Replace individual role assignments with **AAD group** membership. Remove direct role assignment User and Service Principal and add as member of AAD Group. Filter by Owner, Contributor, AA-Reader+ and identify named SP and Users at RG scope. (Low Hanging Fruit)
- The script’s CSV output can help identify candidates for consolidation:
  - Filter `principal_type` by **User** or **Service Principal**
  - Filter `role_name` by **Owner**, **Contributor**, **AA-Reader+**
  - Review `scope` column for assignments at RG or subscription level.

### 3. Consolidate Frequently Used Resource Type Roles

**Context**:

Least Privilege role per Azure Resource Type exist. In some cases, the use of these is prevalent contributing to role assignment count.

**Action**:

- Identify roles with **numerous role assignments** at same scope and consider consolidate into AAD group, if applicable.

# Role assignments that DO NOT contribute to the 4000 limit

- Any principal whose name begins with the prefix "GaaS" are inherited from the Management Group scope and is excluded from the 4,000 role assignment limit.  These assignments are created by the GaaS team as part of Azure Policy implementations.

- Likewise, role assignments that are inherited from a Management Group scope (i.e., scope = Management Group (Inherited)) do not count toward the 4,000 assignment limit.

# Remove redundant role assignments

To reduce the number of role assignments in the subscription, remove redundant role assignments. Follow these steps to identify where redundant role assignments at a lower scope can potentially be removed since a role assignment at a higher scope already grants access.

1. Sign in to the Azure portal and open the Azure Resource Graph Explorer.
2. Select Scope and set the scope for the query.
3. Select `Set authorization scope` and set the authorization scope to `At, above and below` to query all resources at the specified scope.
4. Run the query RBAC.kql in this folder to get the role assignments with the same role and same principal, but at different scopes.

This query checks active role assignments and doesn't consider eligible role assignments in Microsoft Entra Privileged Identity Management. To list eligible role assignments, you can use the Microsoft Entra admin center, PowerShell, or REST API. For more information, see Get-AzRoleEligibilityScheduleInstance or Role Eligibility Schedule Instances - List For Scope.

Please refer file [RBAC.kql](scripts/role-assignment-4000-limit/RBAC.kql). The count_ column is the number of different scopes for role assignments with the same role and same principal. The count is sorted in descending order.

5. Use `RoleDefinitionId`, `RoleDefinitionName`, and `PrincipalId` to get the role and principal ID.
6. Use `Scopes` to get the list of scopes for the same role and same principal.
7. Determine which scope is required for the role assignment. The other role assignments can be removed.
