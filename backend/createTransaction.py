import json
import os
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']

def handler(event, context):
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
            'statusCode': 201,
            'body': json.dumps({'message': 'Created'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }