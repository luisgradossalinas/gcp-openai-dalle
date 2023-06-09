# Google Cloud integration with Dall-e (OpenAI) and WhatsApp

<img width="900" src="https://user-images.githubusercontent.com/2066453/236971336-4e5a5585-f5ba-4985-a182-97bad6df2b32.png">

## Requisitos

- [Tener una cuenta en Google Cloud](https://gist.github.com/luisgradossalinas/d719e4ebc0478c4a189b5e318382b2bc)
- [Tener una cuenta en OpenAI](https://gist.github.com/luisgradossalinas/45c1c5ed27b7f73e0d3cf3bc0fbe846d)
- [Tener una cuenta en UltraMSG](https://gist.github.com/luisgradossalinas/1380c0b42f85ed3a46e7e9ede4249f09)

Accedemos al servicio de Cloud Shell.

<img width="505" src="https://user-images.githubusercontent.com/2066453/237439655-c712bc03-fb4a-49cd-b6e2-3acd13c67dac.png">

Aparecerá la siguiente pantalla, clic en Terminal - New terminal.

<img width="505" src="https://user-images.githubusercontent.com/2066453/220939457-804d371a-5627-451b-95bf-1e705d35b074.png">

En el terminal ejecutamos lo siguiente (reemplazamos los valores).

	export PROJECT_ID=TUPROJECTID
    export OPENAI_APIKEY=TUKEY

Clonamos el repositorio, ejecutamos en el terminal.

	git clone https://github.com/luisgradossalinas/gcp-openai-dalle

Habilitar las APIs.

    gcloud services enable secretmanager.googleapis.com cloudfunctions.googleapis.com iam.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com run.googleapis.com firestore.googleapis.com pubsub.googleapis.com --project $PROJECT_ID

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

## Desplegar recurso en Cloud Run desde Cloud Shell

En la parte inferior clic en Cloud Code y aparecerán varias opciones, seleccionar **Deploy to Cloud Run**.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972074-a5dd1aae-960c-4b92-8f1e-20edd29b71b0.png">

Definimos una variable de entorno, clic en Show Advanced Settings

GOOGLE_CLOUD_PROJECT:TUPROJECTID

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972306-98bb9629-7678-441c-9f13-d28dbf7b201f.png">

Clic en Deploy, esperamos un minutos que se cree el recurso en Cloud Run.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972477-21d5fbab-46d8-4834-9ce8-84bd657dc19c.png">

Clic a la URL generadA y se abrirá una página con el formulario web.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972564-705a964f-4eec-4b72-a143-baab90d11632.png">

Ingresamos datos en el formulario, que generará una imagen en Dall-e y será enviada por WhatsApp.

<img width="700" src="https://user-images.githubusercontent.com/2066453/236972960-7ab49057-c35a-4003-aeb6-708411abf409.png">

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/4a4e8df6-3990-48c1-a776-6db77e3a1180)

Texto a generar en Dall-e por ejemplo : **Mont Saint Michel of France from an aerial view in the day**

Luego se te enviará la imagen generada en Dall-e por WhatsApp.

<img width="700" src="https://user-images.githubusercontent.com/2066453/237465373-5ba783cd-607c-4cbf-a8f0-d6b5eca907fe.png">

- [Fotos en internet del Mont Saint Michael](https://www.google.com/search?q=monte+san+michel&rlz=1C1VDKB_esPE1048PE1048&sxsrf=APwXEdeo1CdQ8bVS91sl31hgNNQaSPHfGQ:1683651144020&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjCufWi2ej-AhXkCLkGHSmDBGEQ_AUoAnoECAEQBA&biw=1536&bih=754&dpr=1.25)

## Revisando registro en BigQuery

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/516db03b-597f-4ce7-9ba4-7b7194d6893c)

## Revisando registro en Firestore

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/f78ff938-7ddf-46ed-9b49-297b6272a8fd)

## Imagen almacenada en Cloud Storage

![image](https://github.com/luisgradossalinas/gcp-openai-dalle/assets/2066453/61668a8b-c1e0-4aa8-ba15-5e09df945475)

## Puedes probar también enviando un mensaje directo al tema de Pub/Sub desde Gcloud.

	gcloud pubsub topics publish topic-dalle-streaming --attribute name="Tu nombre",cel=Tu celular ejemplo 51987654670,msg="3D render of a floating futuristic castle in a clear sky digital art"

## Imagen generada por Dall-e

<img width="700" src="https://user-images.githubusercontent.com/2066453/237440771-5ec9db9b-ad37-4f9e-bce9-b392fcea8249.png">

## Agradecimientos

Espero te haya servido esta solución, si pudiste replicarlo, puedes publicarlo en LinkedIn con tus aportes, cambios y etiquétame (https://www.linkedin.com/in/luisgrados).

## Eliminar recursos

No olvidar eliminar los recursos, para no incurrir en costos inesperados.

Ejecutar en Cloud Shell, desde la carpeta iac.

	terraform destroy --auto-approve

Si se tiene problemas al eliminar los recursos desde Terraform, realizarlo manualmente.

	gcloud run services delete flask-web-dalle --region us-central1
	bq rm -r -d -f $PROJECT_ID:ds_dalle
	gcloud storage ls | grep images | awk {'print "gcloud storage rm --recursive " $1 " "'} | sh
	gcloud pubsub topics delete topic-dalle-streaming
	gcloud functions delete fnc-dalle-generate-image
	gcloud secrets delete OPENAI_APIKEY
	gcloud secrets delete ULTRAMSG

Si se desea mantener los recursos creados, tener en cuenta el precio de cada servicio.
