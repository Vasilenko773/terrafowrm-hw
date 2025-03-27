variable "mysql_root_password" {
  description = "Пароль суперпользователя"
  type        = string
  sensitive   = true
}

variable "mysql_password" {
  description = "Пароль пользователя"
  type        = string
  sensitive   = true
}

variable "mysql_user" {
  description = "Пользователь"
  type        = string
  default     = "wordpress"
}

variable "mysql_database" {
  description = "Наименование БД"
  type        = string
  default     = "wordpress"
}
