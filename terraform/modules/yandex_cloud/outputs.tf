output "cluster_id" {
  value = yandex_kubernetes_cluster.default.id
}

output "user_server" {
  value = var.user_server
}
