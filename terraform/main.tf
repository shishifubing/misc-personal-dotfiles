# setup infrastructure, create a kubernetes cluster
module "yandex_cloud" {
  source = "./modules/yandex_cloud"

  provider_folder_id           = var.yc_folder_id
  provider_cloud_id            = var.yc_cloud_id
  provider_authorized_key_path = var.yc_authorized_key_path
  provider_zone                = var.yc_zone
  domain                       = var.domain
  domain_internal              = var.domain_internal
  domain_top_redirect          = var.domain_top_redirect
  kubernetes_version           = var.kubernetes_version
}

# deploy to the cluster
module "cluster" {
  source = "./modules/cluster"
  depends_on = [
    module.yandex_cloud
  ]
}
