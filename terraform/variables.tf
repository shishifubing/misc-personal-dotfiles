variable "yc_folder_id" {
  description = "folder id for Yandex Cloud"
  default     = "b1gvfdje7hs1nuc9bf6c"
}

variable "yc_cloud_id" {
  description = "cloud id for Yandex Cloud"
  default     = "b1g6b0d8t955ku781jab"
}

variable "yc_authorized_key_path" {
  description = "path to the authorized key file"
  default     = "~/Credentials/yc/authorized_key.personal.json"
}

variable "yc_zone" {
  description = "yandex cloud zone"
  default     = "ru-central1-a"
}

variable "domain" {
  description = "domain for public Cloud DNS"
  default     = "jingyangzhenren.com"
}

variable "domain_internal" {
  description = "domain for internal Cloud DNS"
  default     = "internal"
}

variable "domain_top_redirect" {
  description = "redirect for the top public DNS domain (CNAME)"
  default     = "jingyangzhenren.github.io"
}

variable "kubernetes_version" {
  description = "kubernetes version"
  default     = "1.23"
}

variable "kubernetes_config_path" {
  description = "path to the kubernetes config file"
  default     = "~/.kube/config"
}

variable "kubernetes_context" {
  description = "name of the context to use"
  default     = "personal"
}
