terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.140.1"
    }
  }
  required_version = ">=1.8.4"
}

resource "yandex_vpc_network" "network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "sub_network" {
  name           = var.vpc_name
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.cidr
}
