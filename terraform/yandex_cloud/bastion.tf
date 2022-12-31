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
      image_id = data.yandex_compute_image.image_nginx
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    # public ip
    nat = true
  }

  metadata = {
    user-data = data.cloud-init
  }
}

output "message" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${var.server_user}@${var.domain}
    internal ip: ${yandex_compute_instance.bastion.network_interface.0.ip_address}
    external ip: ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
  EOT
}
