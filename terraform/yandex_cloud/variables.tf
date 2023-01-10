variable "folder_id" {
  description = "folder id in Yandex Cloud"
  default     = "b1gj88s9qiugmqf25in5"
}

variable "cloud_id" {
  description = "cloud id in yandex cloud"
  default     = "b1gqddgifa46u024ko1t"
}

variable "authorized_key" {
  description = "authorized key for yandex cloud"
}

variable "zone" {
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
  default     = "jingyangzhenren-com.github.io"
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
