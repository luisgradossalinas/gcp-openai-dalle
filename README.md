# gcp-openai-dalle

<img width="900" src="https://user-images.githubusercontent.com/2066453/236971336-4e5a5585-f5ba-4985-a182-97bad6df2b32.png">

## Requisitos

- [Tener una cuenta en Google Cloud](https://gist.github.com/luisgradossalinas/d719e4ebc0478c4a189b5e318382b2bc)
- [Tener una cuenta en OpenAI](https://gist.github.com/luisgradossalinas/45c1c5ed27b7f73e0d3cf3bc0fbe846d)
- [Tener una cuenta en UltraMSG](https://gist.github.com/luisgradossalinas/1380c0b42f85ed3a46e7e9ede4249f09)

En Cloud Shell.

	export PROJECT_ID=TUPROJECTID
    export OPENAI_APIKEY=TUKEY
	export ULTRAMSG_INSTANCE=TUINSTANCE
	export ULTRAMSG_TOKEN=TUTOKEN

Habilitar las APIs

    gcloud services enable iam.googleapis.com

Ejecutar.

	gcloud config set project $PROJECT_ID

Ejecutar en Cloud Shell.

	cd gcp-openai-dalle/iac
	terraform init

Crear los recursos en Google Cloud.

	terraform apply -var="project=$PROJECT_ID" -var="openai_apikey=$OPENAI_APIKEY" -var 'ultramsg={"instance": "$ULTRAMSG_INSTANCE", "token": "$ULTRAMSG_TOKEN"}'

gcloud pubsub topics publish topic-dalle-streaming --attribute name="Martin",cel=51987603599,msg="Mount Saint Michael of France from an aerial view"


## Desplegar Cloud Run con formulario web

Ir a Cloud y clic en la parte inferior donde dice Cloud Code -> Deploy to Cloud Run.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972074-a5dd1aae-960c-4b92-8f1e-20edd29b71b0.png">

Definimos una variable de entorno, clic en Show Advanced Settings

GOOGLE_CLOUD_PROJECT:TUPROJECTID

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972306-98bb9629-7678-441c-9f13-d28dbf7b201f.png">

Clic en Deploy, esperamos un minutos que se cree el recurso en Cloud Run.





