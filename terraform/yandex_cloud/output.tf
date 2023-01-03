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
