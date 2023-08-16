import logging
import os

logger = logging.getLogger()

def lambda_handler(event, context):
    http_method = event["requestContext"]["http"]["method"]
    
    hello_value = os.environ["hello_value"]
    
    if http_method == "GET":
        return {
            "statusCode": 200,
            "body": hello_value
        }
    elif http_method == "POST":
        return {
            "statusCode": 200,
            "body": hello_value
        }
    elif http_method == "DELETE":
        return {
            "statusCode": 200,
            "body": f"[DELETE METHOD] {hello_value}"
        }
    elif http_method == "PUT":
        return {
            "statusCode": 200,
            "body": f"[PUT METHOD] {hello_value}"
}