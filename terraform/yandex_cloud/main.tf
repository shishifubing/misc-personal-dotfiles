# setup infrastructure, create a kubernetes cluster
module "main" {
  source = "./modules/main"

  folder_id           = data.yandex_resourcemanager_folder.target.folder_id
  cloud_id            = data.yandex_resourcemanager_cloud.target.cloud_id
  authorized_key_path = var.yc_authorized_key_path
  zone                = var.yc_zone
  domain              = var.domain
  domain_internal     = var.domain_internal
  domain_top_redirect = var.domain_top_redirect
  kubernetes_version  = var.kubernetes_version
}

# setup the kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  ingress_authorized_key = module.main.cluster_ingress_authorized_key
  folder_id              = var.yc_folder_id
  cluster_id             = module.main.cluster_id
}
