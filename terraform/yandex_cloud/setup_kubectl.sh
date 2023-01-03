#!/usr/bin/env bash
set -euxo pipefail

yc init                                                 \
    --token "$(terraform output -raw oauth_token_path)" \
    --folder-id "$(terraform output -raw folder_id)"    \
    --cloud-id "$(terraform output -raw cloud_id)"      \
    --profile "default"
yc managed-kubernetes cluster get-credentials       \
  "$(terraform output -raw cluster_id)"             \
  --internal                                        \
  --folder-id "$(terraform output -raw folder_id )"
kubectl cluster-info