output "vm_details" {
  value = [
    {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.platform.metadata["fqdn"]
    },
    {
      instance_name = yandex_compute_instance.instance_db.name
      external_ip   = yandex_compute_instance.instance_db.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.instance_db.metadata["fqdn"]
    }
  ]
}
