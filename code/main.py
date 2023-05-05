import os
from google.cloud import bigquery
from google.cloud import firestore
from google.cloud import pubsub_v1

import json
import openai
import base64
import requests
import uuid
from datetime import datetime
from datetime import timedelta
import time
import urllib.parse

# Construct a BigQuery client object.
client = bigquery.Client()

bucket_name = os.environ.get('BUCKET_NAME')
project = os.environ.get('PROJECT_ID')
dataset_id = os.environ.get('DATASET_BRONZE')

db = firestore.Client(project = project)

table_ref = db.collection('table')
docs = table_ref.stream()

def main_handler(request):

    #open ai

    #creation

    #whatsapp

    #insert datastore

    #insert bigquery

    print("entrando al cloud functions")

    #print("Se cargaron las siguientes tablas en BigQuery " + dataset_id + " : " + ",".join(tables))
    
    return 'Ok'