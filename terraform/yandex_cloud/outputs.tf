output "access" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${module.main.user_server}@bastion.${var.domain}
    setup ssh: echo "$(terraform output -raw ssh_config)" >>"~/.ssh/config"
  EOT
}

output "ssh_config" {
  value = <<-EOT
    Host bastion
      HostName bastion.${var.domain}
      User ${module.main.user_server}
    Host master
      HostName master.${var.domain_internal}
    Host k8snode1
      HostName k8snode1.${var.domain_internal}
      ProxyJump bastion
  EOT
}

output "domain" {
  value = var.domain
}

output "master_domain" {
  value = "master.${var.domain}"
}


output "cloud_id" {
  value = var.cloud_id
}
output "folder_id" {
  value = var.folder_id
}

output "cluster_id" {
  value = module.main.cluster_id
}
