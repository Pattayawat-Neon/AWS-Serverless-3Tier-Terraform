import json
import os
import boto3
import logging
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']

CORS_HEADERS = {
    "Access-Control-Allow-Origin":
        "http://daily-finance-frontend-prod.s3-website-us-east-1.amazonaws.com",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
}

def handler(event, context):
    logger.info(f'Event: {event}')
    # รองรับ preflight (สำคัญมาก)
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": ""
        }

    try:
        logger.info('Creating transaction')
        body = json.loads(event.get('body', '{}'))
        logger.info(f'Body: {body}')

        table = dynamodb.Table(TABLE_NAME)
        item = {
            'pk': 'USER#demo',
            'sk': f'TX#{int(datetime.now().timestamp() * 1000)}',
            **body,
            'createdAt': datetime.now().isoformat()
        }
        logger.info(f'Item: {item}')
        table.put_item(Item=item)
        logger.info('Transaction created')

        return {
            "statusCode": 201,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": "Created"})
        }

    except Exception as e:
        logger.error(f'Error: {str(e)}')
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)})
        }
