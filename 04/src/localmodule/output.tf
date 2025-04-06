output "network" {
  value = yandex_vpc_network.network.*
}

output "subnet" {
  value = yandex_vpc_subnet.sub_network.*
}

output "subnet_id" {
  value = yandex_vpc_subnet.sub_network.id
}