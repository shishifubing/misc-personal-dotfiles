data "yandex_compute_image" "image_base" {
  family    = var.image_family["base"]
  folder_id = var.provider_folder_id
}

#data "yandex_compute_image" "image_nginx" {
#  family = var.image_family["nginx"]
#  folder_id = var.provider_folder_id
#}
