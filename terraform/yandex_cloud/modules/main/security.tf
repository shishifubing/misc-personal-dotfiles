locals {
  cluster_ip_blocks = concat(
    yandex_vpc_subnet.cluster.v4_cidr_blocks,
    [
      yandex_kubernetes_cluster.default.cluster_ipv4_range,
      yandex_kubernetes_cluster.default.service_ipv4_range
    ],
  )
}

resource "yandex_kms_symmetric_key" "cluster" {
  name              = "cluster"
  description       = "key for the default kubernetes cluster"
  default_algorithm = "AES_128"
  rotation_period   = "7000h" # ~10 month
}

resource "yandex_iam_service_account_key" "cluster_ingress" {
  service_account_id = yandex_iam_service_account.cluster_ingress.id
  description        = "authorized key for the cluster ingress (terraform)"
  key_algorithm      = "RSA_4096"
}

resource "yandex_vpc_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allow incoming and outgoing TCP traffic on port 22"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow incoming TCP ssh connections"
    protocol       = "ANY"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "allow outgoing TCP ssh connections"
    protocol       = "ANY"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "allow_443" {
  name        = "allow_443"
  description = "allow incoming 443 taffic and all outgoing"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow incoming 443 port connections"
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "allow outgoing 443 port connections"
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "allow_80_outgoing" {
  name        = "allow_80_outgoing"
  description = "allow outgoing connections on port 80"
  network_id  = yandex_vpc_network.default.id

  egress {
    description    = "allow outgoing connections on port 80"
    protocol       = "ANY"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "allow_outgoing" {
  name        = "allow_outgoing"
  description = "allow all outgoing connections"
  network_id  = yandex_vpc_network.default.id

  egress {
    description    = "allow all outgoing connections"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "allow_incoming" {
  name        = "allow_incoming"
  description = "allow all incoming connections"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow all incoming connections"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "allow_subnet_default" {
  name        = "allow_subnet_default"
  description = "allow all default subnet connections"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow all connections from the default subnet"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = yandex_vpc_subnet.default.v4_cidr_blocks
  }

  egress {
    description    = "allow all connections to the default subnet"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = yandex_vpc_subnet.default.v4_cidr_blocks
  }
}



resource "yandex_vpc_security_group" "allow_incoming_balancer_master" {
  name        = "allow_incoming_balancer_master"
  description = "allow connections from the load balancer for the master"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow all connections from the cluster subnet"
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = ["${local.master_balancer_external}/32"]
  }
}
