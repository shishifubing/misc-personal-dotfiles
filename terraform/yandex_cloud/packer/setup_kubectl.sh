#!/usr/bin/env bash
set -euxo pipefail

yc managed-kubernetes cluster get-credentials \
    --internal                                \
    --name default
kubectl cluster-info
yc managed-kubernetes cluster get --format json |    \
  jq -r .master.master_auth.cluster_ca_certificate | \
  awk '{gsub(/\\n/,"\n")}1'                          \
  >"${HOME}/Credentials/yc/ca.pem"

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
set -x
echo "${token}" >"${HOME}/Credentials/yc/sa_admin_token.txt"

echo "
    to setup kubectl locally, please run:
    scp bastion:setup_kubectl_locally.sh ./
    ./setup_kubectl_locally.sh
"