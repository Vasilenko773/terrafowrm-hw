###cloud vars

variable "env" {
  type = string
  default = "test"
}

variable "component_web_type" {
  type = string
  default = "web-service"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "web_zone" {
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
  default     = "web-net"
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

### Переменные для DB

variable "vpc_db_name" {
  type        = string
  default     = "db-net"
  description = "VPC network & subnet name"
}

variable "db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "db_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "component_db_type" {
  type = string
  default = "db-server"
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



