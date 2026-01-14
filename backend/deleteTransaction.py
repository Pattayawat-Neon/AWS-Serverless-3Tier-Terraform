import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']

def handler(event, context):
    try:
        sk = event['pathParameters']['sk']
        table = dynamodb.Table(TABLE_NAME)
        table.delete_item(
            Key={
                'pk': 'USER#demo',
                'sk': sk
            }
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Deleted'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }