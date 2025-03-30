

locals {
  web_vm_name = "${var.env}-${var.component_web_type}"
  db_vm_name = "${var.env}-${var.component_db_type}"
}
