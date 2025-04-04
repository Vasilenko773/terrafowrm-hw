resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = flatten([
    for vm in yandex_compute_instance.virtual_machine : [
      {
        name               = vm.name
        nat_ip_address     = vm.network_interface[0].nat_ip_address
        fqdn               = vm.metadata["fqdn"]
      }
    ]
    ])
    databases = [
    for vm in yandex_compute_instance.virtual_db : {
      name           = vm.name
      nat_ip_address = vm.network_interface[0].nat_ip_address
      fqdn           = vm.metadata["fqdn"]
    }
    ]
    storage = [
    for vm in flatten([yandex_compute_instance.vm_singleton]) : {
      name               = vm.name
      nat_ip_address     = vm.network_interface[0].nat_ip_address
      fqdn               = vm.metadata["fqdn"]
    }
    ]
    line_separator = "\n"
  })
  filename = "${abspath(path.module)}/hosts.ini"
}


