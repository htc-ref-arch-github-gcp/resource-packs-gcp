locals {
  # Name restrictions https://cloud.google.com/sql/docs/postgres/instance-settings
  # The total length of project-ID:instance-ID must be 98 characters or less.
  default_name = substr("${var.prefix}${var.app_id}-${var.env_id}-${replace(var.res_id, ".", "-")}", 0, 98 - length(var.project))

  default_database = "main"
  default_username = "main"
}

resource "google_sql_database_instance" "main" {
  name = coalesce(var.name, local.default_name)

  database_version = var.database_version

  # Disable deletion protection as otherwise Humanitec can't delete the database
  deletion_protection = false

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.private_network
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "google_sql_database" "main" {
  name     = local.default_database
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "main" {
  name     = local.default_username
  instance = google_sql_database_instance.main.name
  password = random_password.password.result
}
