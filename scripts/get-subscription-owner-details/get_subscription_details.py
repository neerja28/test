from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import SubscriptionClient
from azure.mgmt.authorization import AuthorizationManagementClient
from msgraph_core import GraphClientFactory
import json
import requests
import concurrent.futures
import psutil
import pandas as pd
from datetime import datetime
import logging

# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("get_subscription_details")  # Set logger name

# Set the logging level for the 'requests' library to WARNING to suppress less important logs
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("azure").setLevel(logging.WARNING)
logging.getLogger('msal.authority').setLevel(logging.WARNING)

def generate_html_body(subscriptions_over_3_owners):
    # data is now the list subscriptions_over_3_owners
    data = subscriptions_over_3_owners

    # HTML header and style
    html_content = '''
<h2>Subscription With More Than Three Owners</h2>
<body>
    <h3>Subscriptions with Multiple Owners</h3>
    <div style=\\"display: flex; flex-wrap: wrap; gap: 20px;\\">
    '''

    # Generate HTML card for each subscription
    for index, subscription in enumerate(data, start=1):
        html_content += f'''
        <div style=\\"border: 1px solid #ccc; padding: 20px; width: 300px; border-radius: 5px; box-shadow: 2px 2px 12px #aaa;\\">
            <h4 style=\\"font-size: 16px;\\">#{index}: {subscription["subscription_name"]}</h4>
            <p><strong>Subscription ID:</strong> {subscription["subscription_id"]}</p>
            <p><strong>Owners:</strong> {", ".join(subscription["owners"])}</p>
        </div>
        '''

    # HTML footer
    html_content += '''
    </div>
</body>
    '''

    # Save HTML content to file
    with open('scripts/get-subscription-owner-details/subscriptions_report.html', 'w') as file:
        file.write(html_content)

    print("HTML report generated successfully!")




def list_subscriptions():
    credential = DefaultAzureCredential()
    subscription_client = SubscriptionClient(credential)
    subscriptions = subscription_client.subscriptions.list()
    return [{'subscription_id': sub.subscription_id, 'subscription_name': sub.display_name} for sub in subscriptions]

def get_subscription_roles(subscription_id):
    credential = DefaultAzureCredential()
    authorization_client = AuthorizationManagementClient(credential, subscription_id)
    role_assignments = authorization_client.role_assignments.list_for_scope('/subscriptions/' + subscription_id)
    role_assignments_list = list(role_assignments)
    return role_assignments_list

def get_ad_group_members(group_object_id, subscription_id, resolved_groups=None):
    if resolved_groups is None:
        resolved_groups = set()

    credential = DefaultAzureCredential()
    client = GraphClientFactory().create_with_default_middleware(credential)
    access_token = credential.get_token("https://graph.microsoft.com/.default").token
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }

    members = []
    next_link = f'https://graph.microsoft.com/v1.0/groups/{group_object_id}/members'
    
    try:
        while next_link:
            response = requests.get(next_link, headers=headers)
            if response.status_code == 200:
                result = response.json()
                if 'value' in result:
                    for member in result['value']:
                        member_id = member['id']
                        member_type = member['@odata.type']
                        if member_type == '#microsoft.graph.user':
                            user_details, error = get_user_details(member_id, subscription_id)
                            if error:
                                logger.error(f"Error: {error}")
                                continue
                            members.append({'id': member_id, 'display_name': user_details.get('displayName', 'Unknown')})
                        elif member_type == '#microsoft.graph.group' and member_id not in resolved_groups:
                            resolved_groups.add(member_id)
                            group_details, error = get_ad_group_details(member_id, subscription_id)  # Get group details
                            if error:
                                logger.error(f"Error: {error}")
                                continue
                            nested_members, error = get_ad_group_members(member_id, subscription_id, resolved_groups)
                            if error:
                                logger.error(f"Error: {error}")
                                continue
                            members.append({
                                'id': member_id,
                                'display_name': group_details.get('displayName', 'Unknown'),  # Capture nested group name
                                'type': 'NestedGroup',  # Indicate as NestedGroup
                                'members': nested_members
                            })
                        else:
                            members.append({'id': member_id, 'display_name': member.get('displayName', 'Unknown')})
                next_link = result.get('@odata.nextLink')
            else:
                return ([], f"Error fetching group members for group {group_object_id}: {response.text}. Subscription ID: {subscription_id}")

        return (members, None)
    except Exception as e:
        return ([], f"Error fetching group members for group {group_object_id} in Subscription ID: {subscription_id}: {e}.")

def get_ad_group_details(group_object_id, subscription_id):
    credential = DefaultAzureCredential()
    client = GraphClientFactory().create_with_default_middleware(credential)
    access_token = credential.get_token("https://graph.microsoft.com/.default").token
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }

    try:
        response = requests.get(f'https://graph.microsoft.com/v1.0/groups/{group_object_id}', headers=headers)
        if response.status_code == 200:
            group_details = response.json()
            return (group_details, None)
        else:
            return (None, f"Error fetching group details for group {group_object_id}: {response.text}. Subscription ID: {subscription_id}")
    except Exception as e:
        return (None, f"Error fetching group details for group {group_object_id} in Subscription ID: {subscription_id}: {e}.")

def get_ad_app_details(app_object_id, subscription_id):
    credential = DefaultAzureCredential()
    client = GraphClientFactory().create_with_default_middleware(credential)
    access_token = credential.get_token("https://graph.microsoft.com/.default").token
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }

    try:
        response = requests.get(f'https://graph.microsoft.com/v1.0/servicePrincipals/{app_object_id}', headers=headers)
        if response.status_code == 200:
            app_details = response.json()
            return (app_details, None)
        else:
            return (None, f"Error fetching app details for service principal {app_object_id}: {response.text}. Subscription ID: {subscription_id}")
    except Exception as e:
        return (None, f"Error fetching app details for service principal {app_object_id} in Subscription ID: {subscription_id}: {e}.")

def get_user_details(user_object_id, subscription_id):
    credential = DefaultAzureCredential()
    client = GraphClientFactory().create_with_default_middleware(credential)
    access_token = credential.get_token("https://graph.microsoft.com/.default").token
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }

    try:
        response = requests.get(f'https://graph.microsoft.com/v1.0/users/{user_object_id}', headers=headers)
        if response.status_code == 200:
            user_details = response.json()
            return (user_details, None)
        else:
            return (None, f"Error fetching user details for user {user_object_id}: {response.text}. Subscription ID: {subscription_id}")
    except Exception as e:
        return (None, f"Error fetching user details for user {user_object_id} in Subscription ID: {subscription_id}: {e}.")

def fetch_subscription_details(subscription_id):
    subscription_roles = get_subscription_roles(subscription_id)
    subscription_details = {}
    role_mapping = {
        '8e3af657-a8ff-443c-a75c-2fe8c4bcb635': 'Owner',
        'b24988ac-6180-42a0-ab88-20f7382dd24c': 'Contributor'
    }
    for role in subscription_roles:
        role_definition_id = role.role_definition_id
        role_definition_id_short = role_definition_id.split('/')[-1]
        if role_definition_id_short not in role_mapping:
            continue

        if role.scope != f'/subscriptions/{subscription_id}':
            continue

        role_name = role_mapping[role_definition_id_short]
        principal_type = role.principal_type
        principal_id = role.principal_id
        ad_group_members = None
        principal_display_name = 'Unknown'

        if principal_type == 'Group':
            group_details, error = get_ad_group_details(principal_id, subscription_id)
            if error:
                logger.error(f"Error: {error}")
                continue
            else:
                principal_display_name = group_details.get('displayName', 'Unknown')
                ad_group_members, error = get_ad_group_members(principal_id, subscription_id)
                if error:
                    logger.error(f"Error: {error}")
                    continue
            subscription_details.setdefault(role_name, []).append({
                'principal_type': principal_type,
                'principal_id': principal_id,
                'display_name': principal_display_name,
                'members': ad_group_members
            })
        elif principal_type in ['ServicePrincipal', 'Application']:
            app_details, error = get_ad_app_details(principal_id, subscription_id)
            if error:
                logger.error(f"Error: {error}")
                continue
            else:
                principal_display_name = app_details.get('displayName', 'Unknown')
            subscription_details.setdefault(role_name, []).append({
                'principal_type': principal_type,
                'principal_id': principal_id,
                'display_name': principal_display_name
            })
        elif principal_type == 'User':
            user_details, error = get_user_details(principal_id, subscription_id)
            if error:
                logger.error(f"Error: {error}")
                continue
            else:
                principal_display_name = user_details.get('displayName', 'Unknown')
            subscription_details.setdefault(role_name, []).append({
                'principal_type': principal_type,
                'principal_id': principal_id,
                'display_name': principal_display_name
            })

    return subscription_details

def json_to_excel(subscriptions_data, output_file='./scripts/get-subscription-owner-details/subscriptions_report.xlsx'):
    """
    Converts the nested JSON subscription data into a flat DataFrame and saves it as an Excel file.
    """
    rows = []

    for subscription_id, sub_data in subscriptions_data.items():
        for role_name, role_assignments in sub_data.get('details', {}).items():
            for assignment in role_assignments:
                principal_type = assignment['principal_type']
                principal_id = assignment['principal_id']
                display_name = assignment.get('display_name') or assignment.get('app_name') or principal_id
                members = assignment.get('members')

                if principal_type == 'User':
                    rows.append({
                        'SubscriptionId': subscription_id,
                        'SubscriptionName': sub_data.get('subscription_name'),
                        'RoleDefinitionName': role_name,
                        'ObjectType': principal_type,
                        'DisplayName': display_name,
                        'MemberId': principal_id,
                        'MemberName': display_name
                    })

                # Handle AD groups with multiple members
                elif members:
                    for member in members:
                        if 'members' in member:
                            rows.append({
                                'SubscriptionId': subscription_id,
                                'SubscriptionName': sub_data.get('subscription_name'),
                                'RoleDefinitionName': role_name,
                                'ObjectType': 'NestedGroup',
                                'DisplayName': member.get('display_name', ''),
                                'MemberId': member.get('id', ''),
                                'MemberName': member.get('display_name', '')
                            })
                            for nested_member in member['members']:
                                rows.append({
                                    'SubscriptionId': subscription_id,
                                    'SubscriptionName': sub_data.get('subscription_name'),
                                    'RoleDefinitionName': role_name,
                                    'ObjectType': 'NestedGroupMember',
                                    'DisplayName': nested_member.get('display_name', ''),
                                    'MemberId': nested_member.get('id', ''),
                                    'MemberName': nested_member.get('display_name', '')
                                })
                        else:
                            rows.append({
                                'SubscriptionId': subscription_id,
                                'SubscriptionName': sub_data.get('subscription_name'),
                                'RoleDefinitionName': role_name,
                                'ObjectType': principal_type,
                                'DisplayName': display_name,
                                'MemberId': member.get('id', ''),
                                'MemberName': member.get('display_name', '')
                            })
                else:
                    rows.append({
                        'SubscriptionId': subscription_id,
                        'SubscriptionName': sub_data.get('subscription_name'),
                        'RoleDefinitionName': role_name,
                        'ObjectType': principal_type,
                        'DisplayName': display_name,
                        'MemberId': '',
                        'MemberName': ''
                    })

    try:
        df = pd.DataFrame(rows)
        df.to_excel(output_file, index=False)
        logger.info(f"Subscription details exported to {output_file}")

    except Exception as e:
        logger.error(f"Error exporting to Excel: {e}")

def load_exceptions(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

def is_subscription_in_exception(subscription_id, exceptions):
    for exception in exceptions:
        if exception['subscription_id'] == subscription_id:
            expiration_date = datetime.strptime(exception['expiration_date'], "%Y-%m-%d")
            if datetime.now() > expiration_date:
                return False  # Expired
            return True
    return False

def generate_output_json(subscriptions_data, exceptions, output_file='./scripts/get-subscription-owner-details/subscriptions_over_3_owners.json'):
    result = []

    def is_subscription_expired(exception):
        expiration_date = datetime.strptime(exception['expiration_date'], "%Y-%m-%d")
        return datetime.now() > expiration_date

    exception_dict = {ex['subscription_id']: ex for ex in exceptions['exceptions']}

    def count_owners_and_collect_names(members):
        owner_count = 0
        owners = []
        for member in members:
            if 'type' in member and member['type'] == 'NestedGroup':
                nested_count, nested_owners = count_owners_and_collect_names(member.get('members', []))
                owner_count += nested_count
                owners.extend(nested_owners)
            else:
                owner_count += 1
                owners.append(member.get('display_name', 'Unknown'))
        return owner_count, owners

    for subscription_id, sub_data in subscriptions_data.items():
        for role_name, role_assignments in sub_data.get('details', {}).items():
            if role_name == 'Owner':
                owner_count = 0
                owners = []

                for assignment in role_assignments:
                    if assignment['principal_type'] == 'User':
                        owner_count += 1
                        owners.append(assignment['display_name'])
                    elif 'members' in assignment:
                        count, member_owners = count_owners_and_collect_names(assignment['members'])
                        owner_count += count
                        owners.extend(member_owners)

                if owner_count > 3:
                    if subscription_id in exception_dict:
                        if is_subscription_expired(exception_dict[subscription_id]):
                            result.append({
                                'subscription_id': subscription_id,
                                'subscription_name': sub_data.get('subscription_name'),
                                'owners': owners
                            })
                    else:
                        result.append({
                            'subscription_id': subscription_id,
                            'subscription_name': sub_data.get('subscription_name'),
                            'owners': owners
                        })

    with open(output_file, 'w') as file:
        json.dump(result, file, indent=4)
        logger.info(f"Subscriptions with more than 3 owners exported to {output_file}")
        logger.info(f"Subscriptions with more than 3 owners: \n{json.dumps(result, indent=4)}")
    
    return result

def main():
    subscriptions = list_subscriptions()
    threads_count = psutil.cpu_count(logical=False)
    if subscriptions:
        max_threads = min(threads_count, len(subscriptions))

        with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
            futures = [executor.submit(fetch_subscription_details, sub['subscription_id']) for sub in subscriptions]
            concurrent.futures.wait(futures)
            results = [future.result() for future in futures]

        subscriptions_data = {sub['subscription_id']: {
                                'subscription_name': sub['subscription_name'],
                                'details': details
                            } for sub, details in zip(subscriptions, results)}

        with open('./scripts/get-subscription-owner-details/subscriptions_data.json', 'w') as json_file:
            json.dump(subscriptions_data, json_file, indent=4)

        json_to_excel(subscriptions_data)  # Call the json_to_excel function

        exceptions = load_exceptions('./scripts/get-subscription-owner-details/exception.json')
        subscriptions_over_3_owners = generate_output_json(subscriptions_data, exceptions)
        if subscriptions_over_3_owners:
            generate_html_body(subscriptions_over_3_owners)

if __name__ == "__main__":
    main()
