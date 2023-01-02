locals {
  bastion     = yandex_compute_instance.bastion
  bastion_ip  = local.bastion.network_interface.0.ip_address
  bastion_nat = local.bastion.network_interface.0.nat_ip_address
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  description = "bastion host with public IP"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image_base.id
      type     = "network-hdd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    security_group_ids = [
      yandex_vpc_security_group.allow_ssh.id
    ]
    # public ip
    nat = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
