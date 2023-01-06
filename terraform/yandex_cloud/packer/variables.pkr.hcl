variable "provider_folder_id" {
  description = "folder id for Yandex Cloud"
  type        = string
  default     = "b1gvfdje7hs1nuc9bf6c"
}

variable "provider_cloud_id" {
  description = "cloud id for Yandex Cloud"
  type        = string
  default     = "b1g6b0d8t955ku781jab"
}

variable "provider_authorized_key_path" {
  description = "path to the authorized key file"
  type        = string
  default     = "~/Credentials/yc/authorized_key.personal.json"
}

variable "provider_authorized_key_path_editor" {
  description = "path to the editor authorized key file"
  type        = string
  default     = "~/Credentials/yc/authorized_key.editor.json"
}

variable "provider_zone" {
  description = "yandex cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "user_server" {
  description = "admin user for all servers"
  type        = string
  default     = "jingyangzhenren"
}

variable "ssh_key_path_main_pub" {
  description = "path to the main public ssh key"
  type        = string
  default     = "~/.ssh/id_main.pub"
}

variable "ssh_key_path_main" {
  description = "path to the main private ssh key"
  type        = string
  default     = "~/.ssh/id_main"
}

variable "ssh_key_path_personal_pub" {
  description = "path to the personal public ssh key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_path_ci" {
  description = "path to the ci private ssh key"
  type        = string
  default     = "~/.ssh/id_ci"
}
variable "ssh_key_path_ci_pub" {
  description = "path to the ci public ssh key"
  type        = string
  default     = "~/.ssh/id_ci.pub"
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
    nginx  = "debian-11-nginx"
    runner = "debian-11-runner"
    base   = "debian-11-base"
    source = "debian-11"
  }
}