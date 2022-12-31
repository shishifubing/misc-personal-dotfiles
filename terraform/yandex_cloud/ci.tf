locals {
  ci_ips = [yandex_compute_instance.ci.network_interface.*.ip_address]
}

resource "yandex_compute_instance_group" "ci" {
  name        = "ci"
  description = "ci runner instance group"
  instance_template {
    name        = "ci${instance.index}"
    hostname    = "ci${instance.index}.${var.domain_internal}"
    description = "ci runner instance (${instance.index})"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.image_base
      }
    }

    network_interface {
      subnet_id = yandex_vpc_subnet.default.id
    }

    metadata = {
      user-data = data.cloud-init
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}



output "message1" {
  value = <<-EOT
    access the website: https://ci.${var.domain}
    connect via ssh: ${var.server_user}@ci.${var.domain}

    internal ip: ${local.ci_ip}
    external ip: ${yandex_compute_instance.ci.network_interface.0.nat_ip_address}
  EOT
}
