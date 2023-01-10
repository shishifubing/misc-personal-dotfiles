#!/usr/bin/env bash
set -Eeuxo pipefail

cloud_id="${1}"
folder_id="${2}"
cluster_id="${3}"

# setup local kubectl
yc managed-kubernetes cluster get-credentials \
    "${cluster_id}"                           \
    --internal                                \
    --cloud-id "${cloud_id}"                  \
    --folder-id "${folder_id}"                \
    --context-name "${cluster_id}"            \
    --force
kubectl cluster-info

# get cluster certificate authority
yc managed-kubernetes cluster get                          \
    "${cluster_id}"                                        \
    --cloud-id "${cloud_id}"                               \
    --folder-id "${folder_id}"                             \
    --format json                                          |
        jq -r ".master.master_auth.cluster_ca_certificate" |
        awk '{gsub(/\\n/,"\n")}1'                          \
    >"${HOME}/Credentials/yc/ca-${cluster_id}.pem"

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kube-system
EOF

secret=$(
    kubectl -n kube-system get secret |
        grep admin-user |
        awk '{print $1}'
)
set +x
token=$(
    kubectl -n kube-system get secret "${secret}" -o json |
        jq -r .data.token |
        base64 --d
)
echo "${token}" >"${HOME}/Credentials/yc/admin_token-${cluster_id}.txt"
set -x