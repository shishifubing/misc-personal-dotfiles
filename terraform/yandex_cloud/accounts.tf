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
