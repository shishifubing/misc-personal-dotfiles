variable "yc_folder_id" {
  description = "folder id for Yandex Cloud"
  type        = string
  default     = "b1gqj05pu00l9g3um77e"
}

variable "yc_cloud_id" {
  description = "cloud id for Yandex Cloud"
  type        = string
  default     = "b1g6b0d8t955ku781jab"
}

variable "yc_authorized_key_path" {
  description = "path to the authorized key file"
  type        = string
  default     = "~/Credentials/yc/authorized_key.personal.json"
}

variable "yc_zone" {
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

variable "domain_top_redirect" {
  description = "redirect for the top public DNS domain (CNAME)"
  type        = string
  default     = "jingyangzhenren.github.io"
}

variable "kubernetes_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.23"
}
