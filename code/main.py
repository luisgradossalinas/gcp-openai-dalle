import os
from google.cloud import bigquery
from google.cloud import firestore
from google.cloud import pubsub_v1

# Construct a BigQuery client object.
client = bigquery.Client()

bucket_name = os.environ.get('BUCKET_NAME')
project = os.environ.get('PROJECT_ID')
dataset_id = os.environ.get('DATASET_BRONZE')

db = firestore.Client(project = project)

table_ref = db.collection('table')
docs = table_ref.stream()

def list_tables():

    list_tables = [] 

    for doc in docs:

        data = (f'{doc.id} => {doc.to_dict()}')
        table = doc.id
        list_tables.append(table) 
    
    return list_tables

def main_handler(request):

    job_config = bigquery.LoadJobConfig(
        write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE, #dynamic, read since catalog dictionary WRITE_TRUNCATE WRITE_APPEND
        source_format = bigquery.SourceFormat.CSV,
        skip_leading_rows = 1,
        max_bad_records = 100000000,
        field_delimiter = "," #by default is , #"\t"
    )

    tables = list_tables()

    for table in tables:

        table_id = project + "." + dataset_id + "." + table

        print("tabla : " + table)

        uri = "gs://" + bucket_name + "/data/" + table + "/" +  table + ".csv"
        print(uri)

        load_job = client.load_table_from_uri(
            uri, table_id, job_config = job_config
        )

        load_job.result()  # Waits for the job to complete.

        destination_table = client.get_table(table_id)
        print("Se insertaron {} registros en la tabla : ".format(destination_table.num_rows) + table)

    print("Se cargaron las siguientes tablas en BigQuery " + dataset_id + " : " + ",".join(tables))
    return 'Ok'
