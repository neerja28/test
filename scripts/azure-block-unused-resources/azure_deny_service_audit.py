import os
import sys
import json
import requests
import concurrent.futures
import time
import psutil
import logging
from azure.identity import DefaultAzureCredential
from azure.mgmt.subscription import SubscriptionClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.resourcegraph import ResourceGraphClient
from azure.mgmt.resourcegraph.models import QueryRequest
from ..github_interactions import *

"""
# Configure the logger to capture all logging levels
"""
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("unused_services")  # Set logger name

"""
# Set the logging level for the 'requests' library to WARNING to suppress less important logs
"""
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("azure").setLevel(logging.WARNING)

"""
# Version Increment
"""
def increment_version(version):
    major, minor, patch = map(int, version.split('.'))

    if patch < 99:
        patch += 1
    else:
        patch = 0
        if minor < 99:
            minor += 1
        else:
            minor = 0
            major += 1

    return f"{major}.{minor}.{patch}"


"""
# Function to convert list to lower
"""
def all_lower(my_list):
    return [x.lower() for x in my_list]

"""
# Function to get a Diff on two lists
"""
def diff(list1, list2):
    list_dif = [i for i in list1 + list2 if i not in list1 or i not in list2]
    return list_dif

"""
# Function To Read JSON File
"""
def read_from_json(file_name=None, folder_path='.'):
    if file_name:
        file_path = os.path.join(folder_path, file_name)
    else:
        file_path = folder_path
    with open(file_path, "r") as file:
        json_data = json.load(file)
    return json_data

"""
# Function To Write JSON To File
""" 
def write_to_json(data, file_name, folder_path='.'):
    file_path = os.path.join(folder_path, file_name)
    with open(file_path, "w") as file:
        json.dump(data, file, indent=2)

"""
# Function to Get Subscriptions
"""
def get_subscriptions(credential):
    subscription_client = SubscriptionClient(credential)
    try:
        subscriptions = subscription_client.subscriptions.list()
        return subscriptions
    except Exception as e:
        logger.error("An error occurred: {}".format(e))
        return []

"""
# Function to get all providers for a given subscription
"""
def get_providers(credential, subscription_id):
    resource_client = ResourceManagementClient(credential, subscription_id)
    try:
        providers = resource_client.providers.list()
        return providers
    except Exception as e:
        logger.error("An error occurred: {}".format(e))
        return []

"""
# Function to get a list of NameSpaces with Blank ResourceTypes
"""
def get_namespaces_with_blank_resource_types(azure_service_list_all_formated, ref_namespaces):
    namespaces_with_blank_resource_types = {"Namespace": []}
    for namespace in ref_namespaces:
        for service in azure_service_list_all_formated["Service"]:
            if namespace in service["Namespace"]:
                if service["ResourceType"] == []:
                    namespaces_with_blank_resource_types["Namespace"].append(namespace)
                break
    return namespaces_with_blank_resource_types


"""
# Function to get all available Namespaces and Resource Types without Capabilities
"""
def get_all_namespaces_and_resource_types(providers):
    azure_service_list_all_formated = {"Service": []}
    azure_service_list_all = {"Service": []}
    azure_namespace_list_all = {"Namespace": []}

    # Capture provider details
    for provider in providers["value"]:
        single_resource = {"Namespace": "", "ResourceType": []}
        azure_namespace_list_all["Namespace"].append(provider["namespace"].lower())
        single_resource["Namespace"] = provider["namespace"].lower()
        for resource_type in provider["resourceTypes"]:
            if resource_type["capabilities"] != "None":
                resource_type_parts = resource_type["resourceType"].split("/")
                if len(resource_type_parts) == 1:
                    single_resource["ResourceType"].append(resource_type["resourceType"].lower())
                    azure_service_list_all["Service"].append(provider["namespace"].lower() + "/" + resource_type["resourceType"].lower())
        azure_service_list_all_formated["Service"].append(single_resource)
    
    return azure_service_list_all_formated, azure_service_list_all, azure_namespace_list_all

"""
# Function to get all available Namespaces and Resource Types with Capabilities
"""
def get_all_namespaces_and_resource_types_with_all_capabilities(providers):
    azure_service_list_all_formated_with_all_capabilities = {"Service": []}
    azure_service_list_all_with_all_capabilities = {"Service": []}

    # Capture provider details
    for provider in providers["value"]:
        single_resource = {"Namespace": "", "ResourceType": []}
        single_resource["Namespace"] = provider["namespace"].lower()
        for resource_type in provider["resourceTypes"]:
            resource_type_parts = resource_type["resourceType"].split("/")
            if len(resource_type_parts) == 1:
                single_resource["ResourceType"].append(resource_type["resourceType"].lower())
                azure_service_list_all_with_all_capabilities["Service"].append(provider["namespace"].lower() + "/" + resource_type["resourceType"].lower())
        azure_service_list_all_formated_with_all_capabilities["Service"].append(single_resource)
    
    return azure_service_list_all_formated_with_all_capabilities, azure_service_list_all_with_all_capabilities

"""
# Function to run Query in Azure Resource Graph Explorer and get used Namespaces and Resource Types
"""
def get_used_resource_types(credential):
    resource_graph_client = ResourceGraphClient(credential)
    query = """
    Resources
    | project type
    | distinct type
    | order by type asc
    """
    query_request = QueryRequest(
        query=query
    )
    try:
        query_response = resource_graph_client.resources(query_request)
        resource_types = [row['type'] for row in query_response.data]
        resource_types.sort()
        azure_service_list_used = {"Service": []}
        for resource_type in resource_types:
            resource_type_parts = resource_type.split("/")
            if len(resource_type_parts) == 2:
                azure_service_list_used["Service"].append(resource_type.lower())
        return azure_service_list_used
    except Exception as e:
        logger.error("An error occurred: {}".format(e))
        return []
    
"""
# Function to Generate Service List from Formated Service List and Namespaces
"""
def generate_service_list(azure_service_list_all_formated, azure_namespace_list):
    azure_service_list = {"Service": []}
    for namespace in azure_namespace_list:
        for service in azure_service_list_all_formated["Service"]:
            if service["Namespace"] == namespace:
                for resource in service["ResourceType"]:
                    azure_service_list["Service"].append(namespace.lower() + "/" + resource.lower())
    return azure_service_list

"""
# Function to Format Services
"""

def format_services(service_list):
    formated_services_list = {"Service": []}
    for item in service_list:
        namespace, resource_type = item.split('/')
        namespace_exists = False
        for service_item in formated_services_list["Service"]:
            if service_item["Namespace"] == namespace:
                service_item["ResourceType"].append(resource_type)
                namespace_exists = True
                break
        if not namespace_exists:
            formated_services_list["Service"].append({"Namespace": namespace, "ResourceType": [resource_type]})

    return formated_services_list

"""
# Function to get Custom Resource Types
"""
def get_custom_resource_types(providers, azure_namespace_list_all):
    azure_custom_resource_types = {"Service": []}
    new_providers = []
    for provider in providers:
        if provider.namespace.lower() not in azure_namespace_list_all["Namespace"]:
            for resource_type in provider.resource_types:
                azure_custom_resource_types["Service"].append(provider.namespace.lower() + "/" + resource_type.resource_type.lower())
            new_providers.append(provider)
    return azure_custom_resource_types, new_providers

"""
# Function to get Custom Resource Types for Subscription (Parallel Processing)
"""
def get_custom_resource_types_for_subscription(subscription, credential, azure_namespace_list_all):
    providers = get_providers(credential, subscription.subscription_id)
    list_of_providers = []
    for provider in providers:
        list_of_providers.append(provider)
    subid_providers = {subscription.subscription_id: list_of_providers}
    azure_custom_resource_types, new_providers = get_custom_resource_types(providers, azure_namespace_list_all)
    result = [azure_custom_resource_types["Service"], new_providers, subid_providers]
    return result

"""
# Function to create folder path
"""
def create_folder_path(folder):
    script_directory = os.path.dirname(os.path.abspath(sys.argv[0]))
    path = str(script_directory) + "/" + folder
    return path

"""
# Function to get latest supported API version for Providers
"""
def get_api_version_for_providers(headers):
    # Specify the Azure Resource Provider for Resource Management
    resource_provider = "Microsoft.Resources"
    # Make the request to the Azure Resource Provider to get available API versions
    # Get the latest known API Version from below link:
    # https://learn.microsoft.com/en-us/rest/api/resources/providers?view=rest-resources-2021-04-01&viewFallbackFrom=rest-resources-2022-12-01
    url = f"https://management.azure.com/providers/{resource_provider}?api-version=2022-12-01"  # Start with a known API version 2022-12-01
    response = requests.get(url, headers=headers)
    # Check if the request was successful
    if response.status_code == 200:
        # Get the supported API versions for Resource Management
        supported_api_versions = []
        for resource_type in response.json().get("resourceTypes", []):
            if resource_type.get("resourceType") == "providers":
                supported_api_versions.extend(resource_type.get("apiVersions", []))
        # Find the latest supported API version dynamically
        #logger.info(f"Supported API versions for {resource_provider}: {supported_api_versions}")
        latest_api_version = max(supported_api_versions)
    return latest_api_version

def update_file_branch(final_schema, policy_json_str, target_branch):
    try:
        policy_path = "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.dev.AA_POLICY_TEST.json"
        commit_comment = f"updated {policy_path}"
        policy_file = get_git_policy_json(owner, repo_name, policy_path, target_branch)
        
        # Check if the policy version exists
        if "version" in policy_file["properties"]["metadata"]:
            policy_version = policy_file["properties"]["metadata"]["version"]
            new_policy_version = increment_version(policy_version)
            # Update the policy version if it exists
            policy_file["properties"]["metadata"]["version"] = new_policy_version
        else:
            logger.warning(f"Version metadata not found in {policy_path}. Skipping version update.")
            new_policy_version = None

        # Update the listOfResourceTypesNotAllowed regardless of version update
        policy_file["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"] = policy_json_str
        update_policy_file(owner, repo_name, policy_path, policy_file, target_branch, commit_comment)

        # Repeat for other policy paths
        policy_path = "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.np.NON-PRODUCTION-MG.json"
        commit_comment = f"updated {policy_path}"
        policy_file = get_git_policy_json(owner, repo_name, policy_path, target_branch)
        if new_policy_version:
            policy_file["properties"]["metadata"]["version"] = new_policy_version
        policy_file["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"] = policy_json_str
        update_policy_file(owner, repo_name, policy_path, policy_file, target_branch, commit_comment)

        policy_path = "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.p.PRODUCTION-MG.json"
        commit_comment = f"updated {policy_path}"
        policy_file = get_git_policy_json(owner, repo_name, policy_path, target_branch)
        if new_policy_version:
            policy_file["properties"]["metadata"]["version"] = new_policy_version
        policy_file["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"] = policy_json_str
        update_policy_file(owner, repo_name, policy_path, policy_file, target_branch, commit_comment)

        logger.info("Updated policy.json file with the latest unused Azure services.")

        # Determine the correct file path based on version existence
        if new_policy_version:
            interim_file_path = f"scripts/azure-block-unused-resources/input_output/final_schema_interim_{new_policy_version}.json"
            commit_comment = f"created {interim_file_path}"
            create_file(owner, repo_name, interim_file_path, json.dumps(final_schema, indent=4), target_branch, commit_comment)
            logger.info(f"Created {interim_file_path} with the latest schema.")
        else:
            final_schema_file_path = "scripts/azure-block-unused-resources/input_output/final_schema.json"
            commit_comment = f"updated {final_schema_file_path}"
            update_policy_file(owner, repo_name, final_schema_file_path, final_schema, target_branch, commit_comment)
            logger.info(f"Updated {final_schema_file_path} with the latest schema.")

    except Exception as e:
        logger.error("Error while updating file: {}".format(e))
        raise e

def process_branch(final_schema, unused_services_new, source_branch, target_branch):
    branch_name = get_child_branch(owner, repo_name, pr_title)
    
    policy_path = "azure/policies/unused-services/AUDIT - Restrict creation of unused azure services/assign.dev.AA_POLICY_TEST.json"
    if branch_name.startswith(f"chore/update-unused-azure-services-"):
        policy_json = get_git_policy_json(owner, repo_name, policy_path, target_branch)
        valid_unused_services = policy_json["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"]
    elif branch_name == "":
        policy_json = get_git_policy_json(owner, repo_name, policy_path)
        valid_unused_services = policy_json["properties"]["parameters"]["listOfResourceTypesNotAllowed"]["value"]
    else:
        return  # No further action needed for this branch type
    
    lower_valid_unused_services = all_lower(valid_unused_services)
    lower_valid_unused_services.sort()
    difference = set(unused_services_new) - set(lower_valid_unused_services)
    difference1 = set(lower_valid_unused_services) - set(unused_services_new)
    
    if len(difference) != 0 or len(difference1) != 0:
        close_pr(owner, repo_name, pr_title)
        delete_branch(owner, repo_name, target_branch)
        create_branch(source_branch, target_branch, owner, repo_name)
        update_file_branch(final_schema, unused_services_new, target_branch)
        raise_pr(source_branch, target_branch, owner, repo_name, pr_title, pr_body)

# Function to classify services based on their lists
def classify_services(resource_type, restricted_services, exception_services):
    if resource_type in restricted_services:
        return "Restricted"
    elif resource_type in exception_services:
        return "Exception"
    else:
        return "Allowed"

# Function to determine if a namespace is core
def is_core_namespace(namespace, core_namespaces):
    return "Yes" if namespace in core_namespaces else "No"

# Function to create the desired schema
def create_schema(api_response, restricted_services, exception_services, core_namespaces):
    schema = {"Providers": []}
    for provider in api_response["value"]:
        single_provider = {"Namespace": "", "Core": "", "RegisteredSubscriptions": [], "ResourceTypes": []}
        if isinstance(provider, dict):
            single_provider["Namespace"] = provider["namespace"].lower()
            single_provider["Core"] = is_core_namespace(single_provider["Namespace"], core_namespaces)
            resource_types = provider["resourceTypes"]
            for resource_type in resource_types:
                resource_type_parts = resource_type["resourceType"].split("/")
                if len(resource_type_parts) == 1:
                    provider_data = {
                        "ResourceType": f"{resource_type['resourceType']}".lower(),
                        "IsResourceTypeOrAction": "ResourceType" if resource_type['capabilities'] != "None" else "Action",
                        "Classification": classify_services(f"{provider['namespace']}/{resource_type['resourceType']}".lower(), restricted_services, exception_services)
                    }
                    single_provider["ResourceTypes"].append(provider_data)
        elif hasattr(provider, 'resource_types'):
            provider = vars(provider)
            single_provider["Namespace"] = provider["namespace"].lower()
            single_provider["Core"] = is_core_namespace(single_provider["Namespace"], core_namespaces)
            resource_types = provider["resource_types"]
            for resource_type in resource_types:
                # Your code here
                resource_type = vars(resource_type)
                resource_type_parts = resource_type["resource_type"].split("/")
                if len(resource_type_parts) == 1:
                    provider_data = {
                        "ResourceType": f"{resource_type['resource_type']}".lower(),
                        "IsResourceTypeOrAction": "ResourceType" if resource_type['capabilities'] != "None" else "Action",
                        "Classification": classify_services(f"{provider['namespace']}/{resource_type['resource_type']}".lower(), restricted_services, exception_services)
                    }
                    single_provider["ResourceTypes"].append(provider_data)
        schema["Providers"].append(single_provider)
    return schema

# Function to remove duplicates from schema
def remove_duplicates(provider_list):
    unique_providers = []
    seen_namespaces = set()

    for provider in provider_list:
        namespace = provider["Namespace"]
        if namespace not in seen_namespaces:
            seen_namespaces.add(namespace)
            unique_providers.append(provider)

    return unique_providers

# Function to update the input_output files using the final schema
def input_files_update(data):
    azure_allowed_namespace = []
    azure_blocked_namespace = []
    azure_allowed_services = []
    azure_blocked_services = []
    azure_core_namespace = []
    azure_exception_services = []

    for provider in data["Providers"]:
        namespace = provider["Namespace"]
        core = provider["Core"]
        resource_types = provider["ResourceTypes"]

        if core.lower() == "yes":
            azure_core_namespace.append(namespace)
            continue

        allowed_count = 0
        restricted_count = 0
        resource_type_count = 0
        for resource in resource_types:
            if resource["Classification"].lower() == "allowed":
                allowed_count += 1
            elif resource["Classification"].lower() == "restricted":
                restricted_count += 1

            if resource["IsResourceTypeOrAction"].lower() == "resourcetype":
                resource_type_count += 1

        if allowed_count == len(resource_types):
            azure_allowed_namespace.append(namespace)
            continue
        elif restricted_count == resource_type_count:
            azure_blocked_namespace.append(namespace)
            continue
        else:
            restricted_resources = []
            allowed_resources = []
            exception_resources = []
            for resource in resource_types:
                if resource["Classification"].lower() == "restricted" and resource["IsResourceTypeOrAction"].lower() == "resourcetype":
                    restricted_resources.append(f"{namespace}/{resource['ResourceType']}")
                elif resource["Classification"].lower() == "allowed" and resource["IsResourceTypeOrAction"].lower() == "resourcetype":
                    allowed_resources.append(f"{namespace}/{resource['ResourceType']}")
                elif resource["Classification"].lower() == "exception" and resource["IsResourceTypeOrAction"].lower() == "resourcetype":
                    exception_resources.append(f"{namespace}/{resource['ResourceType']}")
            
            for resource in restricted_resources:
                if resource not in azure_blocked_services:
                    azure_blocked_services.append(resource)
            for resource in allowed_resources:
                if resource not in azure_allowed_services:
                    azure_allowed_services.append(resource)
            for resource in exception_resources:
                if resource not in azure_exception_services:
                    azure_exception_services.append(resource)

    azure_allowed_namespace.sort()
    azure_blocked_namespace.sort()
    azure_allowed_services.sort()
    azure_blocked_services.sort()
    azure_core_namespace.sort()
    azure_exception_services.sort()

    return azure_allowed_namespace, azure_blocked_namespace, azure_allowed_services, azure_blocked_services, azure_core_namespace, azure_exception_services


# Declaring Global Variables
git_repo = os.getenv('GIT_REPO')
owner, repo_name = git_repo.split('/')
source_branch = "nonprod"
target_branch = "chore/update-unused-azure-services"
pr_title = "chore: Auto Updating Azure Unused Services Audit Policies"
pr_body = "Updated policy files."

"""
# Main Function - test comment
"""
def main():
    global git_repo
    global owner
    global repo_name
    global source_branch
    global target_branch
    global pr_title
    global pr_body

    start_time = time.time()
    
    # Get Subscriptions and Providers
    credential = DefaultAzureCredential()

    # Read Core Services Json Files
    folder_path = create_folder_path("input_output")
    azure_allowed_namespace = read_from_json("azure_allowed_namespace.json", folder_path)
    azure_core_namespace = read_from_json("azure_core_namespace.json", folder_path)

    # Allowed/Approved Services on Tech Radar
    allowed_services = read_from_json("azure_allowed_services.json", folder_path)
    allowed_services["Service"] = [service.lower() for service in allowed_services["Service"]]
    allowed_services["Service"].sort()

    # Get the access token
    access_token = credential.get_token("https://management.azure.com/.default")

    # Set the headers with the correct API version
    headers = {
        "Authorization": f"Bearer {access_token.token}"
    }

    # Specify a valid API version for the Azure Resource Manager
    api_version = get_api_version_for_providers(headers)

    # Make the request to the Azure Resource Explorer
    url = f"https://management.azure.com/providers?api-version={api_version}"
    response = requests.get(url, headers=headers)

    # Check if the request was successful & get All and Used Namespaces/Resource Types
    if response.status_code == 200:
        # Get the providers
        providers = response.json()
        azure_service_list_all_formated, azure_service_list_all, azure_namespace_list_all = get_all_namespaces_and_resource_types(providers)
        azure_service_list_all_formated_with_all_capabilities, azure_service_list_all_with_all_capabilities = get_all_namespaces_and_resource_types_with_all_capabilities(providers)

    # Get Subscription and get the Resource Types that are not captured in Resource Explorer
    subscriptions = get_subscriptions(credential)
    azure_custom_resource_types_all_subscriptions = {"Service": []}
    # Create a ThreadPoolExecutor with a maximum of CPU Cores. EXAMPLE: Thread_Count = Logical/Physical --> threads_count = psutil.cpu_count() / psutil.cpu_count(logical=False)
    threads_count = psutil.cpu_count() #/ psutil.cpu_count(logical=False)
    logger.info("CPU Thread count: %s", threads_count)
    max_threads = threads_count
    with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
        # Use map to concurrently execute the function for each subscription
        results = list(executor.map(
            lambda subscription: get_custom_resource_types_for_subscription(subscription, credential, azure_namespace_list_all),
            subscriptions
        ))
    # Combine the results from all threads
    for result in results:
        azure_custom_resource_types_all_subscriptions["Service"].extend(result[0])

    # Combine the results from all threads for each subscription
    providers_data = {}
    for result in results:
        for key, value in result[2].items():
            if key in providers_data:
                providers_data[key].extend(value)
            else:
                providers_data[key] = value

    # Sort and format the combined results
    azure_custom_resource_types_all_subscriptions["Service"] = sorted(list(set(azure_custom_resource_types_all_subscriptions["Service"])))
    azure_custom_resource_types_all_subscriptions_formated = format_services(azure_custom_resource_types_all_subscriptions["Service"])
    
    # Combine the results from all threads
    azure_service_list_all["Service"].extend(azure_custom_resource_types_all_subscriptions["Service"])
    azure_service_list_all_formated["Service"].extend(azure_custom_resource_types_all_subscriptions_formated["Service"])

    # Get Resource Types that are not present 
    azure_service_list_used = get_used_resource_types(credential)

    # Blocked Services
    blocked_namespace = read_from_json("azure_blocked_namespace.json", folder_path)
    blocked_namespace_services_list = {}
    namespaces_with_blank_resource_types = get_namespaces_with_blank_resource_types(azure_service_list_all_formated, blocked_namespace["Namespace"])
    blocked_namespaces_with_blank_resource_types = generate_service_list(azure_service_list_all_formated_with_all_capabilities, namespaces_with_blank_resource_types["Namespace"])
    blocked_namespace_services_list = generate_service_list(azure_service_list_all_formated, blocked_namespace["Namespace"])
    azure_blocked_services = read_from_json("azure_blocked_services.json", folder_path)
    azure_blocked_services["Service"] = [service.lower() for service in azure_blocked_services["Service"]]
    azure_blocked_services["Service"].sort()
    blocked_services = list(set(azure_blocked_services["Service"] + blocked_namespace_services_list["Service"] + blocked_namespaces_with_blank_resource_types["Service"]))

    # Generate Service List from Formatted Service List and Namespaces
    azure_core_services_list = {}
    azure_core_services_list = generate_service_list(azure_service_list_all_formated, azure_core_namespace["Namespace"])
    azure_allowed_services_list = generate_service_list(azure_service_list_all_formated, azure_allowed_namespace["Namespace"])

    # Unused Services
    azure_exception_services = read_from_json("azure_exception_services.json", folder_path)
    azure_exception_services["Service"] = [service.lower() for service in azure_exception_services["Service"]]
    azure_exception_services["Service"].sort()
    core_allowed_used_services = list(set(azure_core_services_list["Service"] + azure_service_list_used["Service"] + azure_allowed_services_list["Service"] + allowed_services["Service"]))
    core_allowed_used_services.sort()
    unused_services = list(set(diff(list(set(azure_service_list_all["Service"] + core_allowed_used_services)), core_allowed_used_services) + diff(list(set(blocked_services + azure_service_list_used["Service"])), azure_service_list_used["Service"])))
    unused_services.sort()
    unused_services_new = diff(list(set(unused_services + azure_exception_services["Service"])), azure_exception_services["Service"])
    unused_services_new.sort()
    unused_services_list_formated = format_services(unused_services_new)

    #Get Final Schema
    if response.status_code == 200:
        providers = response.json()
        new_providers = []
        for result in results:
            new_providers.extend(result[1])
        providers["value"].extend(new_providers)
        azure_core_namespace["Namespace"] = [namespace.lower() for namespace in azure_core_namespace["Namespace"]]
        final_schema = create_schema(providers, unused_services_new, azure_exception_services["Service"], azure_core_namespace["Namespace"])
        final_schema = remove_duplicates(final_schema["Providers"])
        final_schema = sorted(final_schema, key=lambda x: x["Namespace"])
        final_schema = {"Providers": final_schema}
    # Add subscription_id's to the final schema
    for subscription_id, providers_for_subscription in providers_data.items():
        for provider in final_schema["Providers"]:
            if any(provider["Namespace"] == p.namespace.lower() and p.registration_state == "Registered" for p in providers_for_subscription):
                provider["RegisteredSubscriptions"].append(subscription_id)
    
    # Call the function to process the data and update the input_output files
    azure_allowed_namespace["Namespace"], blocked_namespace["Namespace"], allowed_services["Service"], azure_blocked_services["Service"], azure_core_namespace["Namespace"], azure_exception_services["Service"] = input_files_update(final_schema)

    # Update Branch if new services were detected for blocking 
    process_branch(final_schema, unused_services_new, source_branch, target_branch)

    end_time = time.time()
    execution_time = end_time - start_time
    logger.info("Execution time: %s", execution_time)

if __name__ == "__main__":
    main()
