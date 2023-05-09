# gcp-openai-dalle

![openai-chatgpt-dalle - gcp-dalle](https://user-images.githubusercontent.com/2066453/236551441-765ddcaf-6048-47d6-b043-e1798bdcb308.png)

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

GOOGLE_CLOUD_PROJECT:hypnotic-guard-368114
