import json
import os
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']

CORS_HEADERS = {
    "Access-Control-Allow-Origin":
        "http://daily-finance-frontend-prod.s3-website-us-east-1.amazonaws.com",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
}

def handler(event, context):
    # รองรับ preflight (สำคัญมาก)
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": ""
        }

    try:
        body = json.loads(event.get('body', '{}'))

        table = dynamodb.Table(TABLE_NAME)
        table.put_item(
            Item={
                'pk': 'USER#demo',
                'sk': f'TX#{int(datetime.now().timestamp() * 1000)}',
                **body,
                'createdAt': datetime.now().isoformat()
            }
        )

        return {
            "statusCode": 201,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": "Created"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)})
        }
