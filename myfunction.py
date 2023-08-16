import json
import boto3
from datetime import datetime
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

def read_items_from_dynamodb(table_name):
    table_name = os.environ["DYNAMODB_TABLE"]
    table = dynamodb.Table(table_name)
    
    response = table.scan()
    return response['Items']

def upload_to_s3(bucket_name, file_name, data):
    response = s3.put_object(Bucket=bucket_name, Key=file_name, Body=json.dumps(data))
    return response

def lambda_handler(event, context):
    
    try:
        logger.debug('## ENVIRONMENT VARIABLES')
        logger.debug(os.environ['LOG_BUCKET'])
        logger.debug(os.environ['DYNAMODB_TABLE'])
        logger.debug(os.environ['AWS_LAMBDA_LOG_GROUP_NAME'])
        logger.debug(os.environ['AWS_LAMBDA_LOG_STREAM_NAME'])
        logger.debug('## EVENT')
        logger.debug(event)


        items = []
        table_name = os.environ['DYNAMODB_TABLE']
        user_name = event['userName']
        trigger_source = event['triggerSource']
        user_attributes = event['request']['userAttributes']
        email = user_attributes.get('email', '')
        login_time = datetime.now().isoformat()
        status = 'success' if trigger_source == 'PostConfirmation_ConfirmSignUp' else 'failed'


        logger.debug(f"Event: {event}")
        logger.debug(f"Read 2 {len(items)} items from DynamoDB")
        logger.debug(f"Putting item to table: {table_name}") 
        logger.debug(f"Item to be written: {items}")
        table_name = os.environ["DYNAMODB_TABLE"]
        table = dynamodb.Table(table_name)
        print(table)
        
        table.put_item(
                    TableName=table_name,Item={
                'user_id': user_name,
                'email': email,
                'login_time': login_time,
                'status': status    
            }
        )
        
        bucket_name = os.environ['LOG_BUCKET']
        items = read_items_from_dynamodb(table_name)
        logger.debug(f"Read {len(items)} items")
        file_name = 'dynamodb_items.json'
        upload_to_s3(bucket_name, file_name, items)

        return event
    except Exception as e:
        logger.exception("Error processing event")
        raise e

