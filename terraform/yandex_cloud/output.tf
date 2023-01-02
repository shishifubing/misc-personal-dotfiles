output "access" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${var.user_server}@bastion.${var.domain}

    echo <<EOF >>"~/.ssh/config"

    EOF
  EOT
}

output "cluster_ca" {
  value = yandex_kubernetes_cluster.default.master.0.cluster_ca_certificate
}

output "cluster_endpoint" {
  value = yandex_kubernetes_cluster.default.master.0.internal_v4_endpoint
}

output "ssh_config" {
  value = <<-EOT
    Host bastion
      HostName bastion.${var.domain}
      User ${var.user_server}
    Host master
      HostName master.${var.domain_internal}
  EOT
}
