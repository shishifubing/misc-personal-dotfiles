data "yandex_compute_image" "image_base" {
  family    = var.image_family["base"]
  folder_id = var.provider_folder_id
}

data "yandex_cm_certificate" "master" {
  certificate_id  = yandex_cm_certificate.master.id
  wait_validation = true
}
