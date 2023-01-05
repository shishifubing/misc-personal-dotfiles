resource "helm_release" "ingress_controller" {
  name        = "ingresscontroller"
  description = "ingress controller for the cluster"
  repository  = "oci://cr.yandex/yc"
  chart       = "yc-alb-ingress-controller-chart"

}
