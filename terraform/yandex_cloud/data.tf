data "yandex_resourcemanager_folder" "target" {
  name     = var.yc_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.target.cloud_id
}

data "yandex_resourcemanager_cloud" "target" {
  name = var.yc_cloud_name
}
