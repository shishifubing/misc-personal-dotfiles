locals {
  bastion_ip  = yandex_compute_instance.bastion.network_interface.0.ip_address
  bastion_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

resource "yandex_compute_instance" "bastion" {
  name               = "bastion"
  description        = "bastion host with public IP"
  hostname           = "bastion.${var.domain}"
  service_account_id = yandex_iam_service_account.viewer.id

  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
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
      yandex_vpc_security_group.allow_ssh.id,
      yandex_vpc_security_group.allow_443.id,
      yandex_vpc_security_group.allow_80_outgoing.id
    ]
    # public ip
    nat = true
  }
}
