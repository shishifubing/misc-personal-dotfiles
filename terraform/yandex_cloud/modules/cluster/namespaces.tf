resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace_monitoring
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = var.namespace_ingress
  }
}
