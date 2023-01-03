#!/usr/bin/env bash
set -euxo pipefail

yc init
terraform refresh
yc managed-kubernetes cluster get-credentials       \
  "$(terraform output -raw cluster_id)"             \
  --internal                                        \
  --folder-id "$(terraform output -raw folder_id )"
kubectl cluster-info