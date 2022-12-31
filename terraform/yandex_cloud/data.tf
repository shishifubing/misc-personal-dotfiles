data "yandex_compute_image" "image_base" {
  family = var.yc_image_family["base"]
}

data "yandex_compute_image" "image_nginx" {
  family = var.yc_image_family["nginx"]
}

data "template_file" "cloud-init" {
  template = file("cloud-init.yml")
  vars = {
    main_key    = file("~/.ssh/id_rsa.pub")
    ci_key      = file("~/.ssh/id_ci.pub")
    server_user = var.user_server
    ci_user     = var.user_ci
  }
}
