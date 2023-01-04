
locals {
  master_balancer_external = yandex_vpc_address.cluster.external_ipv4_address.0.address
  master_fqdm              = "master.${var.domain}"
}

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

resource "yandex_dns_recordset" "master_external" {
  zone_id = yandex_dns_zone.public.id
  name    = "master"
  type    = "A"
  ttl     = 200
  data    = [local.master_balancer_external]
}

# it is needed to automatically refresh certificates
# https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/cm_certificate
resource "yandex_cm_certificate" "master" {
  name        = "master"
  description = "certificate for external requests to the master node"
  domains = [
    local.master_fqdm
  ]

  managed {
    challenge_type  = "DNS_CNAME"
    challenge_count = 1
  }
}

resource "yandex_dns_recordset" "master_cname" {
  name    = yandex_cm_certificate.master.challenges.0.dns_name
  type    = yandex_cm_certificate.master.challenges.0.dns_type
  zone_id = yandex_dns_zone.public.id
  data = [
    yandex_cm_certificate.master.challenges.0.dns_value
  ]
  ttl = 60
}
###

# internal DNS

resource "yandex_dns_zone" "internal" {
  name        = "internal"
  description = "internal dns zone"
  zone        = "${var.domain_internal}."
  public      = false
  private_networks = [
    yandex_vpc_network.default.id
  ]
}

resource "yandex_dns_recordset" "master" {
  zone_id = yandex_dns_zone.internal.id
  name    = "master"
  type    = "A"
  ttl     = 200
  data    = [local.master_ip]
}

###

# load balancer the master
resource "yandex_alb_load_balancer" "cluster" {
  name        = "cluster"
  description = "load balancer for the cluster"
  network_id  = yandex_vpc_network.default.id

  allocation_policy {
    location {
      zone_id   = var.provider_zone
      subnet_id = yandex_vpc_subnet.default.id
    }
  }

  listener {
    name = "cluster"
    endpoint {
      address {
        external_ipv4_address {
          address = local.master_balancer_external
        }
      }
      ports = [443]
    }

    tls {
      default_handler {
        certificate_ids = [
          yandex_cm_certificate.master.id
        ]
        http_handler {
          http_router_id = yandex_alb_http_router.cluster.id
        }
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }
}


resource "yandex_alb_http_router" "cluster" {
  name        = "cluster"
  description = "router for the cluster"
}

resource "yandex_vpc_address" "cluster" {
  name        = "cluster"
  description = "external IP address for the cluster"

  external_ipv4_address {
    zone_id = var.provider_zone
  }
}


resource "yandex_alb_virtual_host" "cluster" {
  name           = "cluster"
  http_router_id = yandex_alb_http_router.cluster.id

  route {
    name = "master"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.cluster.id
        timeout          = "30s"
      }
    }
  }
}

resource "yandex_alb_backend_group" "cluster" {
  name        = "cluster"
  description = "backend group for the master"

  http_backend {
    name   = "master"
    weight = 1
    port   = 443
    target_group_ids = [
      yandex_alb_target_group.cluster.id
    ]
    tls {
      sni = local.master_fqdm
    }
    load_balancing_config {
      panic_threshold = 50
    }
    http2 = "true"
  }
}


resource "yandex_alb_target_group" "cluster" {
  name        = "cluster"
  description = "master"

  target {
    subnet_id  = yandex_vpc_subnet.default.id
    ip_address = local.master_ip
  }
}
