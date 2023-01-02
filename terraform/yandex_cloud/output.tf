output "access" {
  value = <<-EOT
    access the website: https://${var.domain}
    connect via ssh: ${var.user_server}@bastion.${var.domain}

    echo <<EOF >>"~/.ssh/config"
      Host bastion
        HostName bastion.${var.domain}
        User ${var.user_server}
      Host ci1
        ProxyJump  ${var.user_server}@bastion.${var.domain}
        HostName ci1.${var.domain_internal}
        User ${var.user_server}
      Host ci2
        ProxyJump  ${var.user_server}@bastion.${var.domain}
        HostName ci2.${var.domain_internal}
        User ${var.user_server}
    EOF
  EOT
}
