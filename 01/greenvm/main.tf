terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yandex_token
  zone      = "ru-central1-d"
  folder_id = "b1gbnhddcun94gv7223u"
}


data "yandex_compute_image" "ubuntu" {
  image_id = "fd8jqt3k7cn48aplvmug"  # Или другая версия Ubuntu
}

resource "yandex_iam_service_account" "my_service_account" {
  name = "my-service-account"
}

# Создание сети
resource "yandex_vpc_network" "default_network" {
  name        = "default_terraform_network"
  folder_id   = "b1gbnhddcun94gv7223u"
  description = "Моя дефолтная сеть"
}

resource "yandex_vpc_route_table" "default_route_table" {
  name       = "default-route-table"
  folder_id  = "b1gbnhddcun94gv7223u"  # Укажите ваш folder_id
  network_id = yandex_vpc_network.default_network.id
}

# Создание подсети в сети
resource "yandex_vpc_subnet" "default_subnet" {
  name           = "default_terraform_subnet"
  zone           = "ru-central1-d"  # Зона, в которой будет находиться подсеть
  network_id     = yandex_vpc_network.default_network.id  # ID сети, в которой будет находиться подсеть
  v4_cidr_blocks = ["10.0.0.0/24"] # Диапазон IP-адресов для подсети
  route_table_id = yandex_vpc_route_table.default_route_table.id  # Использование стандартной таблицы маршрутизации
  folder_id      = yandex_vpc_network.default_network.folder_id
}


resource "yandex_compute_instance" "terraform_ubuntu" {
  name               = "ubuntu-instance"
  zone               = "ru-central1-d"  # Используем доступную зону
  service_account_id = yandex_iam_service_account.my_service_account.id
  platform_id        = "standard-v2"

  resources {
    memory = 2
    cores  = 2
  }


  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet.id
    nat       = true
  }

  metadata = {
    "ssh-keys" = "ubuntu:${file("~/.ssh/id_rsa.pub")}"  # Путь к вашему публичному SSH ключу
  }
}