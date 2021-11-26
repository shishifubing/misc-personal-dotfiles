#!/bin/env bash

### kubernetes

## create a certificate secret
kubernetes_secret_create_sertificate() {

    local name key certificate namespace

    name="${1}"
    namespace="${2:-default}"
    key="${3:-${name}.key}"
    certificate="${4:-${name}.crt}"

    kubectl create secret tls "${name}" \
        --key "${key}" \
        --cert "${certificate}" \
        --namespace "${namespace}"

}

## modify current context
kubernetes_context() {

    kubectl config set-context --current --namespace="${1}"

}

## create an admin role
kubernetes_role() {

    local namespace

    namespace="${1}"

    yaml="

"

}

## create a service account and everything needed
kubernetes_service_account_full() {

    local account namespace role yaml rolebinding

    namespace="${1}"
    account="${2}"
    role="${3}"
    rolebinding="${4}"
    roletype="${5:-Role}"

    kubernetes_service_account "${namespace}" "${account}"
    kubernetes_rolebinding \
        "${namespace}" "${account}" "${role}" "${rolebinding}"

}

kubernetes_rolebinding() {

    local account roletype apigroup namespace role yaml rolebinding

    namespace="${1}"
    account="${2}"
    role="${3}"
    rolebinding="${4:-${role}-rolebinding}"
    roletype="${5:-Role}"
    apigroup="${6:-rbac.authorization.k8s.io}"
    [[ "${roletype}" == "ClusterRole" ]] && apigroup="cluster.${apigroup}"

    kubernetes_apply "
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: ${rolebinding}
          namespace: ${namespace}
        roleRef:
          apiGroup: ${apigroup}
          kind: Role
          name: ${role}
        subjects:
        - namespace: ${namespace}
          kind: ServiceAccount
          name: ${account}
    "
}

kubernetes_service_account() {

    local account namespace

    namespace="${1}"
    account="${2}"

    kubernetes_apply "
        apiVersion: v1
        kind: ServiceAccount
        metadata:
            name: ${account}
            namespace: ${namespace}
    "
}

kubernetes_apply() {

    local yaml="${1}"

    echo "-----------------------"
    echo "${yaml}"
    echo "-----------------------"
    echo "${yaml}" | kubectl apply -f -

}

# get api url
kubernetes_api() {

    kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}'

}
