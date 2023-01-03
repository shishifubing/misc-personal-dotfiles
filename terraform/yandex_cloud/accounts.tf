resource "yandex_iam_service_account" "editor" {
  name        = "editor"
  description = "editor service account"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.provider_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.editor.id}"
  ]
}

resource "yandex_iam_service_account" "viewer" {
  name        = "viewer"
  description = "viewer service account"
}

resource "yandex_resourcemanager_folder_iam_binding" "viewer" {
  folder_id = var.provider_folder_id
  role      = "viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.viewer.id}"
  ]
}
