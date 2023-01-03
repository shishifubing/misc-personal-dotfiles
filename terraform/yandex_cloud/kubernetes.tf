locals {
  master_ip = yandex_kubernetes_cluster.default.master.0.internal_v4_address
  ssh_keys  = <<-EOT
    root:${file(pathexpand(var.ssh_key_path_main_pub))}
    root:${file(pathexpand(var.ssh_key_path_ci_pub))}
    root:${file(pathexpand(var.ssh_key_path_personal_pub))}
  EOT
}

resource "yandex_kubernetes_cluster" "default" {
  name        = "default"
  description = "default kubernetes cluster"
  network_id  = yandex_vpc_network.default.id

  master {
    version   = var.kubernetes_version
    public_ip = false
    security_group_ids = [
      yandex_vpc_security_group.allow_ssh.id,
      yandex_vpc_security_group.allow_443.id,
      yandex_vpc_security_group.allow_outgoing.id
    ]

    zonal {
      subnet_id = yandex_vpc_subnet.default.id
    }

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "02:00"
        duration   = "3h"
      }
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.cluster.id
  }

  service_account_id      = yandex_iam_service_account.editor.id
  node_service_account_id = yandex_iam_service_account.editor.id

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "default" {
  name        = "default"
  description = "default node group"
  cluster_id  = yandex_kubernetes_cluster.default.id
  version     = var.kubernetes_version

  instance_template {
    name        = "k8snode{instance.index}"
    platform_id = "standard-v2"

    network_interface {
      nat        = false
      subnet_ids = [yandex_vpc_subnet.default.id]
      ipv4_dns_records {
        fqdn        = "k8snode{instance.index}"
        dns_zone_id = yandex_dns_zone.internal.id
      }
    }

    metadata = {
      ssh-keys = local.ssh_keys
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
