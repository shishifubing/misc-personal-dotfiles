locals {
  keys_path           = "${path.module}/packer/authorized_keys"
  ssh_authorized_keys = <<-EOT
    root:${file("${local.keys_path}/id_ci.pub")}
    root:${file("${local.keys_path}/id_main.pub")}
    root:${file("${local.keys_path}/id_rsa.pub")}
  EOT
}

# setup infrastructure, create a kubernetes cluster
module "main" {
  source = "./modules/main"

  folder_id           = var.folder_id
  cloud_id            = var.cloud_id
  authorized_key_path = var.authorized_key
  zone                = var.zone
  domain              = var.domain
  domain_internal     = var.domain_internal
  domain_top_redirect = var.domain_top_redirect
  kubernetes_version  = var.kubernetes_version
  ssh_authorized_keys = local.ssh_authorized_keys
}

# setup the kubernetes cluster
module "cluster" {
  source = "./modules/cluster"

  ingress_authorized_key = module.main.cluster_ingress_authorized_key
  folder_id              = var.folder_id
  cluster_id             = module.main.cluster_id
}
