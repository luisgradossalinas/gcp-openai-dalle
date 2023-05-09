resource "random_id" "bucket_prefix" {
  byte_length = 7
}

resource "google_storage_bucket" "images" {
  name                        = "gcp-${random_id.bucket_prefix.hex}-images"
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "source_code" {
  name                        = "gcp-${random_id.bucket_prefix.hex}-source"
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  name   = "code-function.zip"
  bucket = google_storage_bucket.source_code.name
  source = "code-function.zip"
}

resource "google_bigquery_dataset" "dalle_data" {
  dataset_id                  = "ds_dalle"
  description                 = "Dataset dalle"
  location                    = var.region

  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "dalle_table" {
  dataset_id = google_bigquery_dataset.dalle_data.dataset_id
  table_id   = "dalle_data"

  schema = jsonencode([
    {
      "name" : "id",
      "type" : "INT64",
      "mode" : "NULLABLE"
    },
    {
      "name" : "text_input",
      "type" : "STRING",
      "mode" : "NULLABLE"
    },
    {
      "name" : "cel",
      "type" : "STRING",
      "mode" : "NULLABLE"
    },
    {
      "name" : "name",
      "type" : "STRING",
      "mode" : "NULLABLE"
    },
    {
      "name" : "url_img",
      "type" : "STRING",
      "mode" : "NULLABLE"
    },
    {
      "name" : "freg",
      "type" : "DATETIME",
      "mode" : "NULLABLE"
    }
  ])
}

resource "google_secret_manager_secret" "secret-openai" {
  secret_id = "OPENAI_APIKEY"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-openai" {
  secret = google_secret_manager_secret.secret-openai.id
  secret_data = var.openai_apikey
}

resource "google_secret_manager_secret" "secret-ultramsg" {
  secret_id = "ULTRAMSG"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-ultramsg" {
  secret = google_secret_manager_secret.secret-ultramsg.id
  secret_data = var.ultramsg

}

resource "google_pubsub_topic" "topic_streaming" {
  project = var.project
  name    = "topic-dalle-streaming"
}

resource "google_service_account" "sa_function" {
  account_id   = "service-account-function-dalle"
  display_name = "Service Account for use in Cloud Functions"
}

resource "google_project_iam_member" "example_sa_cloudfunctions" {
  project = var.project
  role    = "roles/cloudfunctions.serviceAgent"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_project_iam_member" "example_sa_storage" {
  project = var.project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_project_iam_member" "example_sa_firestore" {
  project = var.project
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_project_iam_member" "example_sa_pubsub" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_project_iam_member" "example_sa_secretmanager" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_project_iam_member" "example_sa_bigquery" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.sa_function.email}"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "fnc-dalle-generate-image"
  location    = var.region
  description = "Read message pub/sub, generate images with Dall-e and send image by WhatsApp"

  event_trigger {
    event_type = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = google_pubsub_topic.topic_streaming.id
  }

  build_config {
    runtime     = "python311"
    entry_point = "main_handler"
    source {
      storage_source {
        bucket = google_storage_bucket.source_code.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 180
    environment_variables = {
        BUCKET_NAME = google_storage_bucket.images.name
        PROJECT_ID = var.project
        DATASET = google_bigquery_dataset.dalle_data.dataset_id
        OPENAI_APIKEY = "OPENAI_APIKEY"
        ULTRAMSG = "ULTRAMSG"
        DALLE_TABLE= "dalle_data"
    }
    service_account_email = google_service_account.sa_function.email
  }
}

output "bucket_images" {
  value = google_storage_bucket.images.name
}

output "cloud_functions_v2" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}