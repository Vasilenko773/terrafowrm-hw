# cat ~/.aws/credentials
# [default]
# aws_access_key_id = YCAJEK...
# aws_secret_access_key = YCMBzZ3...


terraform {
  backend "s3" {
    shared_credentials_file = "~/.terraform/credential.txt"
    profile = "default"
    region = "ru-central1"
    bucket = "tf-state-mr-green"
    key = "dev04/terraform.state"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.


    endpoints = {
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gdsm8q4n3gb93j1gpo/etncnniiv1turvslp9t2"
      s3 = "https://storage.yandexcloud.net"
    }
    dynamodb_table = "tfstate-lock"
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.140.1"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.root_zone
}