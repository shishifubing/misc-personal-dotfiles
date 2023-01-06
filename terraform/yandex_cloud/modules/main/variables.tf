variable "provider_folder_id" {
  description = "folder id for Yandex Cloud"
}

variable "provider_cloud_id" {
  description = "cloud id for Yandex Cloud"
}

variable "provider_authorized_key_path" {
  description = "path to the authorized key file"
}

variable "provider_zone" {
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

variable "ssh_key_path_main_pub" {
  description = "path to the main public ssh key"
  default     = "~/.ssh/id_main.pub"
}

variable "ssh_key_path_main" {
  description = "path to the main private ssh key"
  default     = "~/.ssh/id_main"
}

variable "ssh_key_path_personal_pub" {
  description = "path to the personal public ssh key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_path_ci" {
  description = "path to the ci private ssh key"
  default     = "~/.ssh/id_ci"
}
variable "ssh_key_path_ci_pub" {
  description = "path to the ci public ssh key"
  default     = "~/.ssh/id_ci.pub"
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
