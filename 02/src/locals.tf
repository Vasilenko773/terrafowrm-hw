

locals {
  web_vm_name = "${var.env}-${var.component_web_type}"
  db_vm_name = "${var.env}-${var.component_db_type}"
  ssh_key = "ubuntu:${var.vms_ssh_root_key}"
}
