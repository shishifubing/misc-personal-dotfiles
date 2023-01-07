variable "version" {
  description = "image version"
}

variable "use_nat" {
  description = <<-EOT
    whether to use nat
    (nat is required if the packer client is outside of the network)
  EOT
  type        = bool
  default     = true
}


variable "folder_id" {
  description = "yandex cloud folder id"
  default     = "b1gj88s9qiugmqf25in5"
}

variable "cloud_id" {
  description = "yandex cloud cloud id"
  default     = "b1gqddgifa46u024ko1t"
}

variable "oauth_key" {
  description = "oauth key to setup yc on the bastion server"
  sensitive   = true
}

variable "zone" {
  description = "yandex cloud zone"
  default     = "ru-central1-a"
}

variable "user_server" {
  description = "admin user for all servers"
  default     = "jingyangzhenren"
}

variable "ssh_key_connection" {
  description = "private key used to connect to the instance during build"
  default     = "~/.ssh/id_main"
}
