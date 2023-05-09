import os
from google.cloud import bigquery
from google.cloud import firestore
from google.cloud import pubsub_v1
from google.cloud import secretmanager
from google.cloud import storage
from flask import jsonify
import json
import openai
import base64
import requests
import uuid
from datetime import datetime
from datetime import timedelta
import time
import urllib.parse

bucket_name = os.environ.get('BUCKET_NAME')
project = os.environ.get('PROJECT_ID')
dataset_id = os.environ.get('DATASET')
env_secret_openai = os.environ.get('OPENAI_APIKEY')
env_secret_ultramsg = os.environ.get('ULTRAMSG')
table_dalle = os.environ.get('DALLE_TABLE')

sm = secretmanager.SecretManagerServiceClient()
db = firestore.Client(project = project)
bq = bigquery.Client()
storage = storage.Client()
fs = firestore.Client(project = project)

def main_handler(event, context):

    message = base64.b64decode(event['data']).decode('utf-8') if 'data' in event else ''
    attributes = event.get('attributes', {})
    
    p_name = attributes.get('name')
    p_cel = attributes.get('cel')
    p_msg = attributes.get('msg')

    print(f"Function triggered by messageId {context.event_id} published at {context.timestamp}")
    print("Name: " + p_name)
    print("Cel: " + p_cel)
    print("Msg: " + p_msg)

    secret_openai = f"projects/{project}/secrets/{env_secret_openai}/versions/latest"
    response_openai = sm.access_secret_version(request = {"name": secret_openai})
    secret_value_openai = response_openai.payload.data.decode("UTF-8")

    secret_ultramsg = f"projects/{project}/secrets/{env_secret_ultramsg}/versions/latest"
    response_ultramsg = sm.access_secret_version(request = {"name": secret_ultramsg})
    secret_value_ultramsg = response_ultramsg.payload.data.decode("UTF-8")
    data_ultramsg = json.loads(secret_value_ultramsg)

    instance = data_ultramsg["instance"]
    token = data_ultramsg["token"]

    openai.api_key = secret_value_openai

    response = openai.Image.create(
        prompt = p_msg,
        n = 1,
        size = "256x256"
    )
    
    image_url = response['data'][0]['url']
    print(image_url)

    response = requests.get(image_url)
    image_data = response.content

    file_name = str(uuid.uuid4()) + ".jpg"
    file_path = f"images/{file_name}"

    # Upload image to Cloud Storage
    bucket = storage.get_bucket(bucket_name)
    blob = bucket.blob(file_path)
    blob.upload_from_string(image_data, content_type = response.headers['Content-Type'])

    ## base64 cloud storage
    img_bas64 = base64.b64encode(image_data)
    img_bas64 = urllib.parse.quote_plus(img_bas64)

    output_wsp = p_name + ", the image generated from this text is sent to you (" + p_msg + ")."
    print(output_wsp)

    # Send message by WhatsApp
    payload = "token=" + token + "&to=%2B" + p_cel + "&image=" + img_bas64 + "&caption=" + output_wsp
    payload = payload.encode('utf8').decode('iso-8859-1')
    headers = {'content-type': 'application/x-www-form-urlencoded'}
    url = "https://api.ultramsg.com/" + instance + "/messages/image"
    response = requests.request("POST", url, data = payload, headers = headers)
    print(response)

    collection_name = "dalle_data"

    doc_ref = fs.collection(collection_name).document(str(int(time.time())))

    d = datetime.today() - timedelta(hours = 5, minutes = 0)
    date_reg = str(d.strftime("%Y-%m-%d %H:%M:%S"))  

    doc_data = {
        "text_input" : p_msg,
        "cel" : p_cel,
        "name" : p_name,
        "url_img" : "gs://" + bucket_name + "/" + file_path,
        "freg" : date_reg
    }

    # Save data in Firestore
    doc_ref.set(doc_data)

    # Insert bigquery
    bigquery_data = doc_data
    bigquery_data["id"] = int(time.time())
    table_ref = f"{project}.{dataset_id}.{table_dalle}"
    bq.insert_rows_json(table_ref, [bigquery_data])

    return 'Ok'