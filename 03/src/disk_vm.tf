variable "disk_settings" {
  description = "Настройки диска"
  type        = map(object({
    name = string
    size = number
    type = string
  }))
  default = {
    same = {
      name = "same"
      size = 10
      type = "network-hdd"
    }
  }
}

variable "vm_name" {
  default = "storage"
}

resource "yandex_compute_disk" "vm_count_disk" {
  count = 3
  name  = "${var.disk_settings["same"].name}${count.index}"
  size  = var.disk_settings["same"].size
  type  = var.disk_settings["same"].type
}

resource "yandex_compute_instance" "vm_singleton" {
  name        = var.vm_name
  platform_id = var.vm_setting["min_performance"].platform_id

  resources {
    cores         = var.vm_setting["min_performance"].resources.cores
    memory        = var.vm_setting["min_performance"].resources.memory
    core_fraction = var.vm_setting["min_performance"].resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_setting["min_performance"].scheduling_policy.preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_setting["min_performance"].network_interface.is_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = var.vm_setting["min_performance"].metadata.serial_port_enable
    ssh-keys           = "${var.vm_setting["min_performance"].metadata.ssh_user}:${var.vm_setting["min_performance"].metadata.ssh_key_path}"
  }

  dynamic "secondary_disk" {
    for_each = toset(yandex_compute_disk.vm_count_disk.*.id)
    content {
      disk_id = secondary_disk.value
    }
  }
}