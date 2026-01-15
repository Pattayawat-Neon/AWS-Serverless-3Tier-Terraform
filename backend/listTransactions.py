import json
import os
import boto3
import logging
from boto3.dynamodb.conditions import Key

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
    # รองรับ preflight
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": ""
        }

    try:
        logger.info('Listing transactions')
        table = dynamodb.Table(TABLE_NAME)
        response = table.query(
            KeyConditionExpression=Key("pk").eq("USER#demo")
        )
        logger.info(f'Items: {response.get("Items", [])}')

        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps(response.get("Items", []))
        }

    except Exception as e:
        logger.error(f'Error: {str(e)}')
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)})
        }
