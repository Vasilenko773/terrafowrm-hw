###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vm_os" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Уникальный идентификатор семейста ОС для образа ВМ"
}

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
      vm_name     = "singleton"
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

variable "root_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}