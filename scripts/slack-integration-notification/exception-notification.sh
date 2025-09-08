
curl -X POST -H 'Content-type: application/json' \
    --data  '{ 
        "text": "Policy Exception Pull Request has been Opened!",
        "pr_url": "'"$PR_URL"'",
        "pr_title": "'"$PR_TITLE"'"
    }' $SLACK_EXCEPTION_WEBHOOK_URL