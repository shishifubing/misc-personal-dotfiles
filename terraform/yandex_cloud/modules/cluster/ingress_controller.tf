resource "helm_release" "ingress_controller" {
  name        = "ingresscontroller"
  description = "nginx ingress controller"

  namespace       = kubernetes_namespace.ingress.metadata.0.name
  atomic          = true
  cleanup_on_fail = true

  version    = "v0.1.9"
  chart      = "chart"
  repository = "oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress"

  set_sensitive {
    name = "saKeySecretKey"
    # I have to encode it two times because the first time it makes proper
    # json which is directly injected into the template - it fails
    #
    # commas are escaped because helm provider fails with
    # `has no value (cannot end with ,)`
    value = replace(
      jsonencode(jsonencode(var.ingress_authorized_key)),
      ",",
      "\\,"
    )
  }
  set {
    name  = "folderId"
    value = var.folder_id
  }

  set {
    name  = "clusterId"
    value = var.cluster_id
  }
}
