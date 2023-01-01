resource "yandex_iam_service_account" "ci" {
  name        = "ci"
  description = "service account"
}

resource "yandex_resourcemanager_folder_iam_binding" "ci" {
  folder_id = var.provider_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.ci.id}"
  ]
}
