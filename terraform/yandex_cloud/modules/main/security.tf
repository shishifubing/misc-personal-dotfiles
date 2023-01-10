resource "yandex_kms_symmetric_key" "cluster" {
  name              = "cluster"
  description       = "key for the default kubernetes cluster"
  default_algorithm = "AES_128"
  rotation_period   = "7000h" # ~10 month
}

resource "yandex_iam_service_account_key" "cluster_ingress" {
  service_account_id = yandex_iam_service_account.cluster_ingress.id
  description        = "authorized key for the cluster ingress (terraform)"
  key_algorithm      = "RSA_4096"
}
