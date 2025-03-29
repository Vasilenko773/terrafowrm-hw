variable "vm_db_image_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Уникальный идентификатор семейста ОС для образа ВМ"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "vm_db_platform_setting" {
  type = object({
    vm_name        = string
    platform_id = string
    resources   = object({
      cores         = number
      memory        = number
      core_fraction = number
    })

    scheduling_policy = object({
      preemptible = bool
    })
    network_interface = object({
      is_nat       = bool
    })
    metadata = object({
      serial_port_enable = number
    })
  })
  ### Значения по умолчанию
  default = {
    vm_name     = "netology-develop-platform-db"
    platform_id = "standard-v3"
    resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    scheduling_policy = {
      preemptible = true
    }
    network_interface = {
      is_nat       = true
    }
    metadata = {
      serial_port_enable = 1
    }
  }
  description = "Для конфигурирования платформы!!!"
}


