output "access" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${var.user_server}@bastion.${var.domain}
    setup ssh: echo "$(terraform output -raw ssh_config)" >>"~/.ssh/config"
  EOT
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

output "folder_id" {
  value = var.provider_folder_id
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.default.id
}

output "oauth_token_path" {
  value = pathexpand(var.oauth_token_path)
}
