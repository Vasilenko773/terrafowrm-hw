resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = [
    for vm in yandex_compute_instance.virtual_machine : {
      name               = vm.name
      nat_ip_address     = vm.network_interface[0].nat_ip_address
      fqdn               = vm.metadata["fqdn"]
    }
    ]
    databases = [
    for vm in yandex_compute_instance.virtual_db : {
      name               = vm.name
      nat_ip_address     = vm.network_interface[0].nat_ip_address
      fqdn               = vm.metadata["fqdn"]
    }
    ]
    storage = [
    for vm in [yandex_compute_instance.vm_singleton] : {
        name               = yandex_compute_instance.vm_singleton.name
        nat_ip_address     = yandex_compute_instance.vm_singleton.network_interface[0].nat_ip_address
        fqdn               = yandex_compute_instance.vm_singleton.metadata["fqdn"]
      }
    ]
    line_separator = "\n"
  })
  filename = "${abspath(path.module)}/hosts.ini"
}


