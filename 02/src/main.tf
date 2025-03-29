resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "web_subnet" {
  name           = var.vpc_name
  zone           = var.web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_os_family
}

resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_platform_setting.vm_name
  platform_id = var.vm_web_platform_setting.platform_id
  zone        = var.web_zone

  resources {
    cores         = var.vm_web_platform_setting.resources.cores
    memory        = var.vm_web_platform_setting.resources.memory
    core_fraction = var.vm_web_platform_setting.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_platform_setting.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.web_subnet.id
    nat       = var.vm_web_platform_setting.network_interface.is_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_platform_setting.metadata.serial_port_enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}



