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
resource "yandex_dns_zone" "public" {
  name        = "public"
  description = "public dns zone"
  zone        = "${var.domain}."
  public      = true
}

resource "yandex_dns_recordset" "public" {
  zone_id = yandex_dns_zone.public.id
  name    = "@"
  type    = "CNAME"
  ttl     = 200
  data    = [var.domain_top_redirect]
}

resource "yandex_dns_recordset" "bastion" {
  zone_id = yandex_dns_zone.public.id
  name    = "bastion"
  type    = "A"
  ttl     = 200
  data    = [local.bastion_nat]
}
###

# additional cluster DNS

resource "yandex_dns_zone" "internal" {
  name        = "internal"
  description = "internal dns zone"
  zone        = "${var.domain_internal}."
  public      = false
  private_networks = [
    yandex_vpc_network.default.id
  ]
}

resource "yandex_dns_recordset" "internal" {
  zone_id = yandex_dns_zone.internal.id
  name    = "master"
  type    = "A"
  ttl     = 200
  data    = [local.master_ip]
}

###
