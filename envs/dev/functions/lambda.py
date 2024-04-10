import os
import json

def lambda_handler(event, context):
    return  {
        "statusCode": 200,
        "body": '<html><body><h1>Greetings from Lambda!</h1></body></html>',
        "headers": {
            'Content-Type': 'text/html',
        }
    }