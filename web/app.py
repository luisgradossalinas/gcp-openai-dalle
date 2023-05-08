from flask import Flask, render_template, request
from google.cloud import pubsub_v1
import json
import uuid
import os

app = Flask(__name__)

publisher = pubsub_v1.PublisherClient()
project_id = os.environ["GOOGLE_CLOUD_PROJECT"]
topic_id = "topic-dalle-streaming"

@app.route('/')
def index():
   return render_template("index.html")

@app.route('/submit', methods = ['POST'])
def submit():

    name = request.form['name']
    cel = request.form['cel']
    msg = request.form['msg']

    data = {
        'name': name,
        'cel': cel,
        'msg': msg
    }
    
    list_param = [name, cel, msg]

    topic_path = publisher.topic_path(project_id, topic_id)


    # Enviar un mensaje vacío con los atributos
    future = publisher.publish(topic_path, b'', **data)
    future.result()

    return render_template('success.html', data = list_param)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 8080)