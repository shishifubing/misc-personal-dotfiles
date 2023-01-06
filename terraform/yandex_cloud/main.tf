# setup main infrastructure, create a kubernetes cluster
module "main" {
  source = "./modules/main"

  provider_folder_id           = var.yc_folder_id
  provider_cloud_id            = var.yc_cloud_id
  provider_authorized_key_path = var.yc_authorized_key_path
  provider_zone                = var.yc_zone
  domain                       = var.domain
  domain_internal              = var.domain_internal
  domain_top_redirect          = var.domain_top_redirect
  kubernetes_version           = var.kubernetes_version
}

# kubernetes cluster setup
module "cluster" {
  source = "./modules/cluster"
  depends_on = [
    module.yandex_cloud
  ]

  ingress_authorized_key = module.yandex_cloud.cluster_ingress_authorized_key
  folder_id              = var.yc_folder_id
  cluster_id             = module.yandex_cloud.cluster_id
}
