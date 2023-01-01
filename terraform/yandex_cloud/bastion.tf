resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  description = "bastion host"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image_base.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    # public ip
    nat = true
  }
}

locals {
  bastion_ip  = yandex_compute_instance.bastion.network_interface.0.ip_address
  bastion_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "bastion_message" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${var.user_server}@bastion.${var.domain}
    internal ip: ${local.bastion_ip}
    external ip: ${local.bastion_nat}
  EOT
}
