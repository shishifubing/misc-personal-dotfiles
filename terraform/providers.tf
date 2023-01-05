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
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
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
  config_path    = pathexpand(var.kubernetes_config_path)
  config_context = var.kubernetes_context
}

provider "helm" {
  kubernetes {
    config_path    = pathexpand(var.kubernetes_config_path)
    config_context = var.kubernetes_context
  }

  registry {
    url      = "osi://cr.yandex"
    username = "json_key"
    password = file(pathexpand(var.yc_authorized_key_path))
  }
}
