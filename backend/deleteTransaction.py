import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']

CORS_HEADERS = {
    "Access-Control-Allow-Origin":
        "http://daily-finance-frontend-prod.s3-website-us-east-1.amazonaws.com",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
}

def handler(event, context):
    # รองรับ preflight
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": ""
        }

    try:
        sk = event.get("pathParameters", {}).get("sk")
        if not sk:
            return {
                "statusCode": 400,
                "headers": CORS_HEADERS,
                "body": json.dumps({"error": "Missing sk"})
            }

        table = dynamodb.Table(TABLE_NAME)
        table.delete_item(
            Key={
                "pk": "USER#demo",
                "sk": sk
            }
        )

        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps({"message": "Deleted"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": str(e)})
        }
