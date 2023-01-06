output "cluster_id" {
  value = yandex_kubernetes_cluster.default.id
}

output "user_server" {
  value = var.user_server
}

# have to encode it two times because the first time it makes proper json
# which is directly injected into the template - it fails
# the second time it is encoded into a proper string, but the helm provider
# fails with `has no value (cannot end with ,)`
output "cluster_ingress_authorized_key" {
  value     = yandex_iam_service_account_key.cluster_ingress
  sensitive = true
}
