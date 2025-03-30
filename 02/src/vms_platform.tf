
### ИНФРАСТРУКТУРА СЕРВЕРА С БД
resource "yandex_vpc_subnet" "db_subnet" {
  name           = var.vpc_db_name
  zone           = var.db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.db_cidr
}


data "yandex_compute_image" "db_image" {
  family = var.vm_web_image_os_family
}

resource "yandex_compute_instance" "instance_db" {
  #  depends_on = [yandex_compute_instance.platform]
  name        = var.vm_db_platform_setting.vm_name
  platform_id = var.vm_db_platform_setting.platform_id
  zone =  var.db_zone

  resources {
    cores         = var.vm_db_platform_setting.resources.cores
    memory        = var.vm_db_platform_setting.resources.memory
    core_fraction = var.vm_db_platform_setting.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_platform_setting.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db_subnet.id
    nat       = var.vm_db_platform_setting.network_interface.is_nat
  }

  metadata = {
    serial-port-enable = var.vm_db_platform_setting.metadata.serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
    fqdn               = "db.green.ru"
  }
}
