terraform {
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