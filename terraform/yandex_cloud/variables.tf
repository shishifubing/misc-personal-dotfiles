variable "provider_folder_id" {
  description = "folder id for Yandex Cloud"
  type        = string
  default     = "b1gqj05pu00l9g3um77e"
}

variable "provider_cloud_id" {
  description = "cloud id for Yandex Cloud"
  type        = string
  default     = "b1g6b0d8t955ku781jab"
}

variable "provider_authorized_key_path" {
  description = "path to the authorized key file"
  type        = string
  default     = "~/Credentials/yc/authorized_key.ci.json"
}

variable "provider_zone" {
  description = "yandex cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "domain" {
  description = "domain for public Cloud DNS"
  type        = string
  default     = "jingyangzhenren.com"
}

variable "domain_internal" {
  description = "domain for internal Cloud DNS"
  type        = string
  default     = "internal"
}

variable "domain_github_io" {
  description = "CNAME for github.io"
  type        = string
  default     = "jingyangzhenren.github.io"
}

variable "user_server" {
  description = "admin user for all servers"
  type        = string
  default     = "jingyangzhenren"
}

variable "user_ci" {
  description = "ci user for all servers"
  type        = string
  default     = "ci"
}

variable "image_family" {
  description = "dictionary of image families"
  type        = map(string)

  default = {
    nginx = "debian-11-nginx"
    base  = "debian-11-base"
  }
}
