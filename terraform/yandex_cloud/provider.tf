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
  zone                     = "ru-central1-a"
  service_account_key_file = file("~/Credentials/yc/authorized_key.ci.json")
  folder_id                = "b1gqj05pu00l9g3um77e"
  cloud_id                 = "b1g6b0d8t955ku781jab"
}
