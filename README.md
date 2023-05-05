# gcp-openai-dalle

![openai-chatgpt-dalle - gcp-dalle](https://user-images.githubusercontent.com/2066453/236551441-765ddcaf-6048-47d6-b043-e1798bdcb308.png)

export PROJECT_ID=TUPROJECTID

gcloud config set project $PROJECT_ID

cd iac
terraform init

terraform apply -var="project=$PROJECT_ID" -var="openai_apikey=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"