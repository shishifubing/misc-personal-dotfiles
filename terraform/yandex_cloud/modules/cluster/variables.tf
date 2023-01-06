variable "namespace_monitoring" {
  description = "namespace for monitoring"
  default     = "monitoring"
}

variable "namespace_ingress" {
  description = "namespace for the cluster ingress"
  default     = "ingress"
}

variable "ingress_authorized_key" {
  type        = map(string)
  description = "authorized key for the cluster ingress"
}

variable "folder_id" {
  description = "yandex cloud folder id"
}

variable "cluster_id" {
  description = "yandex cloud cluster id"
}
