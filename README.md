# gcp-openai-dalle

![openai-chatgpt-dalle - gcp-dalle](https://user-images.githubusercontent.com/2066453/236551441-765ddcaf-6048-47d6-b043-e1798bdcb308.png)

En Cloud Shell.

	export PROJECT_ID=TUPROJECTID
    export OPENAI_APIKEY=TUKEY

Habilitar las APIs

    gcloud services enable iam.googleapis.com --project hypnotic-guard-368114

Ejecutar.

	gcloud config set project $PROJECT_ID

Ejecutar en Cloud Shell.

	cd iac
	terraform init

Crear los recursos en Google Cloud.

	terraform apply -var="project=$PROJECT_ID" -var="openai_apikey=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" -var 'ultramsg={"instance": "instance44701", "token": "tgy6vzd34v1t3z5i"}'

gcloud pubsub topics publish topic-dalle-streaming --attribute name="Martin",cel=51987603599,msg="Mount Saint Michael of France from an aerial view"

GOOGLE_CLOUD_PROJECT:hypnotic-guard-368114