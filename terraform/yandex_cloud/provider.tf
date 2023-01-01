# https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone                     = var.provider_zone
  service_account_key_file = pathexpand(var.provider_authorized_key_path)
  folder_id                = var.provider_folder_id
  cloud_id                 = var.provider_cloud_id
}
