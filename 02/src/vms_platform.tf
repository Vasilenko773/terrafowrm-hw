
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
  name        = local.db_vm_name
  platform_id = var.vm_db_platform_setting.platform_id
  zone =  var.db_zone

  resources {
    cores         =  var.vms_resources["db"].cores
    memory        =  var.vms_resources["db"].memory
    core_fraction =  var.vms_resources["db"].core_fraction
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
    serial-port-enable = var.vms_metadata["db"].serial_port_enable
    ssh-keys           = local.ssh_key
    fqdn               = var.vms_metadata["db"].fqdn
  }
}
