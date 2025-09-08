import requests
import logging

# Configure the logger to capture all logging levels
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("apptio_call")  # Set logger name

# Functions to interact with apptio
def get_bearer_token(client_id, client_secret, url = "https://api.aa.com/edgemicro-auth/token"):
    payload = {
        "client_id": client_id,
        "client_secret": client_secret,
        "grant_type": "client_credentials"
    }
    headers = {
        "Content-Type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers)
    
    if response.status_code == 200:
        return response.json().get("access_token")
    else:
        logger.error("Failed to get token: %s %s", response.status_code, response.text)
        return None

def get_budget_api(bearer_token, app_shortname ,url = "https://gaas-cloud-cost-management-apptio-api.cloud.aa.com/apptio/reports/budget/app"):
    headers = {
        "Authorization": f"Bearer {bearer_token}"
    }
    params = {
        "aa_app_shortname": {app_shortname}
    }

    response = requests.get(url, params=params, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    else:
        logger.error("Failed to getbudget: %s %s", response.status_code, response.text)
        return None