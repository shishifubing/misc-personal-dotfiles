# https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone                     = var.yc_zone
  service_account_key_file = pathexpand(var.yc_authorized_key_path)
  folder_id                = var.yc_folder_id
  cloud_id                 = var.yc_cloud_id
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
