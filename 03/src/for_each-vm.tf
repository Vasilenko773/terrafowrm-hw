variable "vm_setting_list" {
  description = "Настройки виртуальных машин c разными cpu/core/ram"

  type = list(object({
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
      ssh_key_path       = string
      ssh_user           = string
    })
    boot_disk = object({
      size     = number    # Размер диска (в ГБ)
      type     = string    # Тип диска (например, "network-hdd", "network-ssd")
      disk_type = string   # Тип диска для использования (например, "network-ssd")
    })
  }))

  default = [
    {
      vm_name     = "main"
      platform_id = "standard-v3"
      resources   = {
        cores         = 2
        memory        = 4
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
        ssh_key_path       = "~/.ssh/id_ed25519.pub"
        ssh_user           = "green773"
      }
      boot_disk = {
        size     = 11
        type     = "network-hdd"
        disk_type = "network-hdd"
      }
    },
    {
      vm_name     = "replica"
      platform_id = "standard-v3"
      resources   = {
        cores         = 2
        memory        = 2
        core_fraction = 50
      }
      scheduling_policy = {
        preemptible = true
      }
      network_interface = {
        is_nat = true
      }
      metadata = {
        serial_port_enable = true
        ssh_key_path       = "~/.ssh/id_ed25519.pub"
        ssh_user           = "green773"
      }
      boot_disk = {
        size     = 10
        type     = "network-hdd"
        disk_type = "network-hdd"
      }
    }
  ]
}


resource "yandex_compute_instance" "virtual_db" {
  for_each = { for idx, vm in var.vm_setting_list : vm.vm_name => vm }

  name        = "db${each.value.vm_name}"
  platform_id = each.value.platform_id

  resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
      size     = each.value.boot_disk.size
      type     = each.value.boot_disk.type
    }
  }

  scheduling_policy {
    preemptible = each.value.scheduling_policy.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = each.value.network_interface.is_nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = each.value.metadata.serial_port_enable
    ssh-keys           = "${each.value.metadata.ssh_user}:${each.value.metadata.ssh_key_path}"
    fqdn               = "db.green${each.value.vm_name}.ru"
  }
}
