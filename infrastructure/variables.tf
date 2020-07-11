variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "application_name" {
  type    = string
  default = "serverless_app"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "github_user_name" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "bucket_name" {
  type = string
}
