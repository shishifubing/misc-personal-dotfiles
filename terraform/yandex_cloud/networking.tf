# networks
resource "yandex_vpc_network" "default" {
  name        = "default"
  description = "default network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "default"
  description    = "default subnet"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

###

# public DNS
resource "yandex_dns_zone" "top" {
  name        = "top"
  description = "public dns zone for the top domain"
  zone        = "${var.domain}."
  public      = true
}

resource "yandex_dns_recordset" "top" {
  zone_id = yandex_dns_zone.top.id
  name    = "@"
  type    = "CNAME"
  ttl     = 200
  data    = [var.domain_github_io]
}

resource "yandex_dns_recordset" "subdomains" {
  zone_id = yandex_dns_zone.top.id
  name    = "*"
  type    = "A"
  ttl     = 200
  data    = [local.bastion_nat]
}
###
