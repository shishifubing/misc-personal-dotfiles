output "access" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${module.yandex_cloud.user_server}@bastion.${var.domain}
    setup ssh: echo "$(terraform output -raw ssh_config)" >>"~/.ssh/config"
  EOT
}

output "ssh_config" {
  value = <<-EOT
    Host bastion
      HostName bastion.${var.domain}
      User ${module.yandex_cloud.user_server}
    Host master
      HostName master.${var.domain_internal}
  EOT
}

output "domain" {
  value = var.domain
}

output "master_domain" {
  value = "master.${var.domain}"
}


output "cloud_id" {
  value = var.yc_cloud_id
}
output "folder_id" {
  value = var.yc_folder_id
}

output "cluster_id" {
  value = module.yandex_cloud.cluster_id
}
