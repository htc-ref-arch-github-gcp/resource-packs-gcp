variable "prefix" {
  type = string
}

variable "name" {
  type    = string
  default = ""
}

variable "app_id" {
  type = string
}

variable "env_id" {
  type = string
}

variable "res_id" {
  type = string
}

variable "project" {
  description = "GCP project ID"
  type        = string
}
