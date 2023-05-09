# gcp-openai-dalle

<img width="900" src="https://user-images.githubusercontent.com/2066453/236971336-4e5a5585-f5ba-4985-a182-97bad6df2b32.png">

## Requisitos

- [Tener una cuenta en Google Cloud](https://gist.github.com/luisgradossalinas/d719e4ebc0478c4a189b5e318382b2bc)
- [Tener una cuenta en OpenAI](https://gist.github.com/luisgradossalinas/45c1c5ed27b7f73e0d3cf3bc0fbe846d)
- [Tener una cuenta en UltraMSG](https://gist.github.com/luisgradossalinas/1380c0b42f85ed3a46e7e9ede4249f09)

Accedemos al servicio de Cloud Shell.

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/8ebebf2f-4a5d-4038-969a-85369523934c)

Aparecerá la siguiente pantalla, clic en Terminal - New terminal.

<img width="505" src="https://user-images.githubusercontent.com/2066453/220939457-804d371a-5627-451b-95bf-1e705d35b074.png">

En el terminal ejecutamos lo siguiente (reemplazamos los valores).

	export PROJECT_ID=TUPROJECTID
    export OPENAI_APIKEY=TUKEY

Ejecutar el siguiente comando en el terminal de linux.

	git clone https://github.com/luisgradossalinas/gcp-openai-dalle

Habilitar las APIs.

    gcloud services enable secretmanager.googleapis.com cloudfunctions.googleapis.com iam.googleapis.com artifactregistry.googleapis.com iam.googleapis.com cloudbuild.googleapis.com run.googleapis.com firestore.googleapis.com --project $PROJECT_ID

Ejecutar.

	gcloud config set project $PROJECT_ID

Ejecutar en Cloud Shell.

	cd gcp-openai-dalle/iac
	terraform init

Crear los recursos en Google Cloud, ingresar los valores de UltraMsg.

	terraform apply -var="project=$PROJECT_ID" -var="openai_apikey=$OPENAI_APIKEY" -var 'ultramsg={"instance": "REPLACE_ULTRAMSG_INSTANCE", "token": "REPLACE_ULTRAMSG_TOKEN"}'

## Activamos Firestore.

Nos vamos al servicio de Firestore, clic en NATIVE MODE.

![firestore01](https://user-images.githubusercontent.com/2066453/220948582-70e3255a-b4d1-487c-b092-b48511813303.png)

Seleccionamos la location : name5 (United States)) y clic en Create database.

![firestore02](https://user-images.githubusercontent.com/2066453/220948628-0c1836f8-acc7-4705-93f4-69bfb6da9270.png)

## Desplegar recurso en Cloud Run

Ir a Cloud y clic en la parte inferior donde dice Cloud Code -> Deploy to Cloud Run.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972074-a5dd1aae-960c-4b92-8f1e-20edd29b71b0.png">

Definimos una variable de entorno, clic en Show Advanced Settings

GOOGLE_CLOUD_PROJECT:TUPROJECTID

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972306-98bb9629-7678-441c-9f13-d28dbf7b201f.png">

Clic en Deploy, esperamos un minutos que se cree el recurso en Cloud Run.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972477-21d5fbab-46d8-4834-9ce8-84bd657dc19c.png">

Clic a la URL generadA y se abrirá una página con el formulario web.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972564-705a964f-4eec-4b72-a143-baab90d11632.png">

Ingresamos datos en el formulario, que generará una imagen en Dall-e y será enviado por WhatsApp.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972960-7ab49057-c35a-4003-aeb6-708411abf409.png">

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/4a4e8df6-3990-48c1-a776-6db77e3a1180)

Texto a generar en Dall-e por ejemplo : Mont Saint Michel of France from an aerial view in the day

Luego se te enviará la imagen generada en Dall-e por WhatsApp.

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/183805df-83ab-45fd-80db-0007e063f2d9)

- [Fotos en internet del Mont Saint Michael](https://www.google.com/search?q=monte+san+michel&rlz=1C1VDKB_esPE1048PE1048&sxsrf=APwXEdeo1CdQ8bVS91sl31hgNNQaSPHfGQ:1683651144020&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjCufWi2ej-AhXkCLkGHSmDBGEQ_AUoAnoECAEQBA&biw=1536&bih=754&dpr=1.25)

## Revisando registro en BigQuery

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/863791d5-c2fb-49ef-8989-2fe1a56de398)

## Revisando registro en Firestore

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/17ffd5d5-516b-4ad0-b186-bd8254ef78cc)

## Imagen almacenada en Cloud Storage

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/9233a0af-ea3e-4502-ba5d-c688272c3111)

## Puedes probar también enviando un mensaje directo al tema de Pub/Sub desde Gcloud.

	gcloud pubsub topics publish topic-dalle-streaming --attribute name="Martin",cel=51987687609,msg="Mont Saint Michael of France from an aerial view"

## Agradecimientos

Espero te haya servido esta solución, si pudiste replicarlo, puedes publicarlo en LinkedIn con tus aportes, cambios y etiquétame (https://www.linkedin.com/in/luisgrados).
