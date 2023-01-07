# accounts
resource "yandex_iam_service_account" "editor" {
  name        = "editor"
  description = "editor service account (terraform)"
}

resource "yandex_iam_service_account" "viewer" {
  name        = "viewer"
  description = "viewer service account (terraform)"
}

resource "yandex_iam_service_account" "cluster_ingress" {
  name        = "clusteringress"
  description = "viewer service account (terraform)"
}
###

# roles
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.editor.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "viewer" {
  folder_id = var.folder_id
  role      = "viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.viewer.id}"
  ]
}


resource "yandex_resourcemanager_folder_iam_binding" "alb_editor" {
  folder_id = var.folder_id
  role      = "alb.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster_ingress.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_publicAdmin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster_ingress.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "certificate_download" {
  folder_id = var.folder_id
  role      = "certificate-manager.certificates.downloader"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster_ingress.id}"
  ]
}


resource "yandex_resourcemanager_folder_iam_binding" "compute_viewer" {
  folder_id = var.folder_id
  role      = "compute.viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.cluster_ingress.id}"
  ]
}
