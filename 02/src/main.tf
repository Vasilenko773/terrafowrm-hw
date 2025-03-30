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
  name        = local.web_vm_name
  platform_id = var.vm_web_platform_setting.platform_id
  zone        = var.web_zone

  resources {
    cores         =  var.vms_resources["web"].cores
    memory        =  var.vms_resources["web"].memory
    core_fraction =  var.vms_resources["web"].core_fraction
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
    serial-port-enable = var.vms_metadata["web"].serial_port_enable
    ssh-keys           = local.ssh_key
    fqdn               = var.vms_metadata["web"].fqdn
  }
}



