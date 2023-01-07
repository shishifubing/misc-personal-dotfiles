#!/usr/bin/env bash
set -Eeuxo pipefail

master_domain="$(terraform output -raw master_domain)"
cloud_id="$(terraform output -raw cloud_id)"
folder_id="$(terraform output -raw folder_id)"
cluster_id="$(terraform output -raw cluster_id)"

# setup kubectl on the bastion host and create admin user in the cluster
# the script is included in the VM image built by packer
ssh bastion "./setup_kubectl.sh ${cloud_id} ${folder_id} ${cluster_id}"

credentials="Credentials/yc"
ca="${credentials}/ca.pem"
token="${credentials}/sa_admin_token.txt"

scp "bastion:${token}"        \
    "bastion:${ca}"           \
    "${HOME}/${credentials}/"

kubectl config set-cluster personal        \
  --certificate-authority="${HOME}/${ca}"  \
  --server="https://${master_domain}"      \
  --tls-server-name="kubernetes"

set +x
kubectl config set-credentials admin-user \
  --token="$(<"${HOME}/${token}")"
set -x
kubectl config set-context personal \
  --cluster=personal                \
  --user=admin-user
kubectl config use-context personal
kubectl cluster-info