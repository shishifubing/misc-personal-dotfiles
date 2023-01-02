resource "yandex_kms_symmetric_key" "cluster" {
  name              = "cluster"
  description       = "key for the default kubernetes cluster"
  default_algorithm = "AES_128"
  rotation_period   = "700h" # ~1 month

  lifecycle {
    prevent_destroy = true
  }
}

resource "yandex_vpc_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allow incoming and outgoing TCP traffic on port 22"
  network_id  = yandex_vpc_network.default.id

  ingress {
    description    = "allow incoming TCP ssh connections"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "allow outgoing TCP ssh connections"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "cluster" {
  name        = "cluster_rules"
  description = "cluster rules"
  network_id  = yandex_vpc_network.default.id


  ingress {
    description    = "allow incoming TCP ssh connections"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "allow incoming 443 port connections"
    protocol       = "ANY"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "allow all outgoing connections"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
