resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.dev_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v3"
  // TODO: опечатка в значении ключа platform_id. Исправленно значение standarT-v*
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
    //TODO: Не допустимые значения cores = 2; core_fraction =5.
    // При указании cores 5 будет выделенно 5 ядер, что увеличит производительность
    // и позволит выполнять больще процессов параллельно.
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
    //TODO: параметр отвечающий за свойство перрываимости у ВМ
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
