locals {
    postfix = <<-EOT
        ${formatdate("YYYY-MM-DD", timestamp())}-${uuidv4()}
    EOT
}

variable "image_version" {
    description = "image version"
    type = string
}

variable "use_nat" {
  description = <<-EOT
    whether to use nat or not
    nat is required if you are outside of the network
  EOT
  type        = bool
  default     = true
}

source "yandex" "debian-nginx" {
  disk_type           = "network-hdd"
  folder_id           = var.provider_folder_id
  image_description   = "edge host"
  image_family        = "debian-11-nginx"
  # this resourse name cannot contain dots
  image_name          = "debiangit-11-nginx-${replace(var.image_version, ".", "-")}"
  source_image_family = "debian-11"
  ssh_username        = "debian"
  service_account_key_file = pathexpand(var.provider_authorized_key_path)
  # nat is required,
  use_ipv4_nat        = var.use_nat
  zone                = var.provider_zone
}

build {
  sources = ["source.yandex.debian-nginx"]

  provisioner "shell" {
    inline = [ <<-EOT
        echo "updating APT"
        sudo apt-get update -y
        sudo apt-get install -y nginx
        sudo su -
        sudo systemctl enable nginx.service
        curl localhost
    EOT
    ]
  }
}
