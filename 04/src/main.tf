
module "vpc_dev" {
  source   = "./localmodule"
  vpc_name = "from_root_module"
  zone     = var.root_zone
  cidr     = ["10.0.1.0/24"]
}

data "yandex_compute_image" "os" {
  family = var.vm_os
}

resource "yandex_compute_instance" "vm_singleton" {
  name         = var.vm_setting["min_performance"].vm_name
  platform_id  = var.vm_setting["min_performance"].platform_id

  resources {
    cores         = var.vm_setting["min_performance"].resources.cores
    memory        = var.vm_setting["min_performance"].resources.memory
    core_fraction = var.vm_setting["min_performance"].resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_setting["min_performance"].scheduling_policy.preemptible
  }

  network_interface {
    subnet_id          = module.vpc_dev.subnet_id
    nat                = var.vm_setting["min_performance"].network_interface.is_nat
  }

  metadata = {
    serial-port-enable = var.vm_setting["min_performance"].metadata.serial_port_enable
    ssh-keys           = "${var.vm_setting["min_performance"].metadata.ssh_user}:${var.vm_setting["min_performance"].metadata.ssh_key_path}"
    fqdn               = "ru.green.storage"
  }
}