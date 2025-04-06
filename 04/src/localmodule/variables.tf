variable "cidr" {
  type        = list(string)
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  description = "Имя VPC"
  type        = string
}

variable "zone" {
  description = "Зона для подсети"
  type        = string
}