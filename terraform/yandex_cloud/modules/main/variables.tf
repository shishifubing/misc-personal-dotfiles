variable "folder_id" {
  description = "folder id for Yandex Cloud"
}

variable "cloud_id" {
  description = "cloud id for Yandex Cloud"
}

variable "authorized_key_path" {
  description = "path to the authorized key file"
}

variable "ssh_authorized_keys" {
  description = "authorized keys for the cluster nodes"
}
variable "zone" {
  description = "yandex cloud zone"
}

variable "domain" {
  description = "domain for public Cloud DNS"
}

variable "domain_internal" {
  description = "domain for internal Cloud DNS"
}

variable "domain_top_redirect" {
  description = "redirect for the top public DNS domain (CNAME)"
}

variable "user_server" {
  description = "admin user for all servers"
  default     = "jingyangzhenren"
}

variable "user_ci" {
  description = "ci user for all servers"
  default     = "ci"
}

variable "image_family" {
  description = "dictionary of image families"
  type        = map(string)

  default = {
    nginx  = "debian-11-nginx"
    runner = "debian-11-runner"
    base   = "debian-11-base"
    source = "debian-11"
  }
}

variable "kubernetes_version" {
  description = "kubernetes version"
}
