#!/usr/bin/env bash
set -euxo pipefail

credentials="Credentials/yc"
ca="${credentials}/ca.pem"
token="${credentials}/sa_admin_token.txt"
scp "bastion:${ca}"           \
    "bastion:${token}"        \
    "${HOME}/${credentials}/"

kubectl config set-cluster personal       \
  --certificate-authority="${HOME}/${ca}" \
  --server=master.jingyangzhenren.com
set +x
kubectl config set-credentials admin-user \
  --token="$(<"${token}")"
set -x
kubectl config set-context personal \
  --cluster=personal                \
  --user=admin-user
kubectl config use-context personal