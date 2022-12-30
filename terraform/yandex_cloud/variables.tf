variable "domain" {
  type        = string
  description = "which domain to use for Cloud DNS"
  default     = "jingyangzhenren.com"
}

variable "server_user" {
  type        = string
  description = "admin user for all servers"
  default     = "jingyangzhenren"
}

variable "ci_user" {
  type        = string
  description = "ci user for all servers"
  default     = "ci"
}
