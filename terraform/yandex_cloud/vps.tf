resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  description = "bastion host"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      # https://cloud.yandex.ru/marketplace/products/yc/ubuntu-22-04-lts
      image_id = "fd8ueg1g3ifoelgdaqhb"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    # public ip
    nat = true
  }

  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    # https://cloudinit.readthedocs.io/en/latest/topics/examples.html
    user-data = templatefile("cloud-init.yml", {
      main_key    = file("~/.ssh/id_rsa.pub")
      ci_key      = file("~/.ssh/id_ci.pub")
      server_user = var.server_user
      ci_user     = var.ci_user
    })
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
