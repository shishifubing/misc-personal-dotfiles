resource "yandex_compute_instance_group" "ci" {
  name               = "ci"
  description        = "ci runner instance group"
  service_account_id = yandex_iam_service_account.ci.id

  instance_template {
    name        = "ci{instance.index}"
    hostname    = "ci{instance.index}.${var.domain_internal}"
    description = "ci runner instance ({instance.index})"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.image_base.id
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.default.id]
    }
  }

  allocation_policy {
    zones = [var.provider_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 2
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
