resource "yandex_vpc_network" "network" {
  name        = "default"
  description = "default network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "default"
  description    = "default subnet"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_dns_zone" "dns_zone" {
  name        = "default"
  description = "default dns zone"
  zone        = "${var.domain}."
  public      = true
  private_networks = [
    yandex_vpc_network.network.id
  ]
}

resource "yandex_dns_recordset" "domain" {
  zone_id = yandex_dns_zone.dns_zone.id
  name    = "*"
  type    = "A"
  ttl     = 200
  data = [
    yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  ]
}

resource "yandex_dns_recordset" "subdomains" {
  zone_id = yandex_dns_recordset.domain.zone_id
  name    = "@"
  type    = yandex_dns_recordset.domain.type
  ttl     = yandex_dns_recordset.domain.ttl
  data    = yandex_dns_recordset.domain.data
}
