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

# public DNS for the top domain
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
###

# public edge router
resource "yandex_alb_http_router" "edge" {
  name        = "edge"
  description = "http edge router"
}

resource "yandex_alb_virtual_host" "edge" {
  name           = "edge"
  http_router_id = yandex_alb_http_router.edge.id
  authority      = ["ci1${instance.index}.${var.domain_internal}"]

  route {
    http_route {

    }
  }

  dynamic "route" {
    for_each = yandex_compute_instance_group.ci.instances
    content {
      name = "ci"
      http_route {
        http_route_action {
          backend_group_id = yandex_alb_backend_group.ci.id
        }

      }
    }
  }
}

resource "yandex_alb_backend_group" "ci" {
  name        = "ci"
  description = "ci runner backend group"

  http_backend {
    name   = "ssh"
    weight = 1
    port   = 22
    target_group_ids = [
      yandex_alb_target_group.ci.id
    ]
  }
}

resource "yandex_alb_target_group" "ci" {
  name        = "ci"
  description = "ci runner target group"

  target {
    subnet_id  = yandex_vpc_subnet.default.id
    ip_address = yandex_compute_grci.network_interface.0.ip_address
  }
}
