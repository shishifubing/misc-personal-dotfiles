data "yandex_compute_image" "image_base" {
  family    = var.image_family["base"]
  folder_id = var.folder_id
}
