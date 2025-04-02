variable "vm_setting" {
  description = "Настройки виртуальной машины"

  type = map(object({
    vm_name        = string
    platform_id    = string
    resources      = object({
      cores         = number
      memory        = number
      core_fraction = number
    })
    scheduling_policy = object({
      preemptible = bool
    })
    network_interface = object({
      is_nat = bool
    })
    metadata = object({
      serial_port_enable = bool
      ssh_key_path = string
      ssh_user = string
    })
  }))

  # Значения по умолчанию
  default = {
    min_performance = {
      vm_name     = "web-"
      platform_id = "standard-v3"
      resources   = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      scheduling_policy = {
        preemptible = true
      }

      network_interface = {
        is_nat = true
      }

      metadata = {
        serial_port_enable = true
        ssh_key_path = "~/.ssh/id_ed25519.pub"
        ssh_user = "green773"
      }
    }
  }
}

resource "yandex_compute_instance" "virtual_machine" {
  count = 2
  name        = "${var.vm_setting["min_performance"].vm_name}${count.index + 1}"
  platform_id = var.vm_setting["min_performance"].platform_id

  resources {
    cores         =  var.vm_setting["min_performance"].resources.cores
    memory        =  var.vm_setting["min_performance"].resources.memory
    core_fraction =  var.vm_setting["min_performance"].resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
    }
  }
  scheduling_policy {
    preemptible =var.vm_setting["min_performance"].scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_setting["min_performance"].network_interface.is_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = var.vm_setting["min_performance"].metadata.serial_port_enable
    ssh-keys           = "${var.vm_setting["min_performance"].metadata.ssh_user}:${var.vm_setting["min_performance"].metadata.ssh_key_path}"
    fqdn               = "db.green${count.index}.ru"
  }
}