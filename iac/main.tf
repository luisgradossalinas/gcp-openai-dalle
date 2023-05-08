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
  dataset_id                  = "dalle_data"
  description                 = "This is a test description"
  location                    = var.region

  delete_contents_on_destroy = true
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

#resource "google_pubsub_subscription" "sub_streaming" {
#  project = var.project
#  name    = "dalle-subscription"
#  topic   = google_pubsub_topic.topic_streaming.name
#}

resource "google_service_account" "sa_function" {
  account_id   = "service-account-function"
  display_name = "Service Account for use in Cloud Functions"
}

resource "google_project_iam_binding" "iam_function" {
  project = var.project
  role    = "roles/workflows.invoker"
  members = [
    "serviceAccount:${google_service_account.sa_function.email}"
  ]
}

resource "google_cloudfunctions2_function" "function" {
  name        = "fnc-dalle-generate-image"
  location    = "us-central1"
  description = "Read message pub/sub and generate images with Dall-e, send image by WhatsApp"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.topic_streaming.id
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
        DATASET_BRONZE = google_bigquery_dataset.bronze.dataset_id
        OPENAI_APIKEY = "OPENAI_APIKEY"
        ULTRAMSG = "ULTRAMSG"
    }
  }
}

output "bucket_images" {
  value = google_storage_bucket.images.name
}

output "cloud_functions_v2" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}

#output "command_output" {
#  value = "sh loadgcs/SH_Load_GCS.sh ${var.project} ${google_storage_bucket.images.name}"
#}