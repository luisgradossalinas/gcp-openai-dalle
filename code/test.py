import sys
import json
import uuid
from datetime import datetime, timezone
import pytz
from google.cloud import pubsub_v1

#python3 test.py

project_id = "hypnotic-guard-368114" #str(sys.argv[1])
topic_id = "topic-dalle-streaming" #str(sys.argv[2]) 

#read value secret manager

#put datastore

#insertr table big query

# put cloud storage image dalle

sys.exit(1)

record = {
    'msg': "dfg"
}

client = pubsub_v1.PublisherClient()
topic_path = client.topic_path(project_id, topic_id)
data = json.dumps(record).encode("utf-8")
client.publish(topic_path, data)

print("Publishing in Pub/Sub")