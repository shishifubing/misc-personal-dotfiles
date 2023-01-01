variable "version" {
    description = "image version"
    type = string
}

variable "use_nat" {
  description = <<-EOT
    whether to use nat or not
    nat is required if packer client is outside of the network
  EOT
  type        = bool
  default     = true
}

locals {
    base = var.image_family["base"]
    source = var.image_family["source"]
    cloud_init = templatefile("cloud-init.yml", {
        key_main    = file(pathexpand(var.ssh_key_path_main_pub))
        key_ci      = file(pathexpand(var.ssh_key_path_ci_pub))
        key_personal = file(pathexpand(var.ssh_key_path_personal_pub))
        server_user = var.user_server
        ci_user     = var.user_ci
    })
}

# https://developer.hashicorp.com/packer/plugins/builders/yandex
source "yandex" "debian-11-base" {
  service_account_key_file = pathexpand(var.provider_authorized_key_path)
  folder_id           = var.provider_folder_id
  zone                = var.provider_zone
  use_ipv4_nat        = var.use_nat
  ssh_username        = var.user_server
  ssh_private_key_file = var.ssh_key_path_main

  disk_type           = "network-hdd"
  image_description   = "base image with configured ssh and users"
  image_family        = local.base
  # this resourse name cannot contain dots
  image_name          = "${local.base}-${var.version}"
  source_image_family = local.source
  metadata = {
    user-data = local.cloud_init
  }
  serial_log_file = "build.log"
}

build {
  sources = ["source.yandex.${local.base}"]

  provisioner "shell" {
    inline = [
        <<-EOT
            echo "waiting for cloud-init"
            while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
                sleep 1
            done
            echo "done"
        EOT
    ]
  }

  post-processor "manifest" {
    output = "image_base.manifest.json"
    strip_path = true
  }
}