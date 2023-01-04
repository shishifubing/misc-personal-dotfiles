variable "version" {
    description = "image version"
    type = string
}

variable "use_nat" {
  description = <<-EOT
    whether to use nat
    (nat is required if the packer client is outside of the network)
  EOT
  type        = bool
  default     = true
}

variable "oauth_token_path" {
  description = <<-EOT
    path to a file with OAuth token for Yandex Cloud
    it is needed for yc
    to get one, visit https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb
  EOT
  type        = string
  default     = "~/Credentials/yc/oauth.txt"
}

locals {
    base = var.image_family["base"]
    source = var.image_family["source"]
    variables = {
        key_main    = file(pathexpand(var.ssh_key_path_main_pub))
        key_ci      = file(pathexpand(var.ssh_key_path_ci_pub))
        key_personal = file(pathexpand(var.ssh_key_path_personal_pub))
        server_user = var.user_server
        ci_user     = var.user_ci
    }
    init_base = templatefile("image_base.cloud-init.yml", local.variables)
}

source "yandex" "debian-11-base" {
  service_account_key_file = pathexpand(var.provider_authorized_key_path)
  folder_id           = var.provider_folder_id
  zone                = var.provider_zone
  use_ipv4_nat        = var.use_nat
  ssh_username        = var.user_server
  ssh_private_key_file = var.ssh_key_path_main

  disk_type           = "network-hdd"
  image_description   = "base debian image with configured ssh and users"
  image_family        = local.base
  # this resourse name cannot contain dots
  image_name          = "${local.base}-${var.version}"
  source_image_family = local.source
  metadata = {
    user-data = join("\n", [
        local.init_base
    ])
  }
  serial_log_file = "image_base.log"
}

build {
  sources = ["source.yandex.${local.base}"]

  provisioner "shell" {
    env = {
      YC_TOKEN =  file(pathexpand(var.oauth_token_path))
    }
    scripts = [
      "setup.sh",
      "image_init_wait.sh",
      "setup_yc.expect"
    ]
  }

  post-processor "manifest" {
    output = "image_base.manifest.json"
    strip_path = true
  }
}
