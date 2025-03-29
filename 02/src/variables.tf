###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "dev_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "заглушка ssh ключа"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_image_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Уникальный идентификатор семейста ОС для образа ВМ"
}

variable "vm_web_platform_setting" {
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
      vm_name     = "netology-develop-platform-web"
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


