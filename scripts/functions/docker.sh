#!/bin/env bash

### kubernetes

## create a certificate secret
kubernetes_secret_create_sertificate() {

    local name key certificate

    name="${1}"
    key="${2:-${name}}"
    certificate="${3:-${name}}"

    kubectl create secret tls "${name}" \
        --key "${key}" \
        --cert "${certificate}"

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

## get token, one line
kubernetes_token() {

    local namespace account_name

    namespace="${1}"
    account_name="${2}"

    sudo kubectl -n "${namespace}" describe secret "$(
        sudo kubectl -n "${namespace}" get secret |
            (grep "${account_name}" || echo "$_") |
            awk '{print $1}'
    )" | grep "token:" | awk '{print $2}'

}

## get token contents
kubernetes_token_() {

    local namespace account_name

    namespace="${1}"
    token_name="${2}"

    kubectl get -n "${namespace}" secret "${token_name}" -o yaml

}

## get token name
kubernetes_token_name() {

    local namespace account_name

    namespace="${1}"
    account_name="${2}"

    kubectl get -n "${namespace}" serviceaccount "${account_name}" -o yaml

}

## launch proxy
kubernetes_proxy() {

    kubectl proxy \
        --accept-hosts '^.*$' \
        --address 'cl-2-master-1' \
        --reject-paths '' \
        --port 8005 \
        -n production \
        example-prod-sample-app

}

## get the application url
kubernetes_application_url() {

    local namespace service NODE_PORT NODE_IP

    namespace="${1}"
    service="${2}"

    NODE_PORT=$(
        kubectl get --namespace "${namespace}" -o \
            jsonpath="{.spec.ports[0].nodePort}" services "${service}"
    )
    NODE_IP=$(
        kubectl get nodes --namespace production -o \
            jsonpath="{.items[0].status.addresses[0].address}"
    )

    echo "http://${NODE_IP}:${NODE_PORT}"
    export NODE_PORT
    export NODE_IP

}

kubernetes_get_token() {

    local namespace secret_name

    namespace="${1}"

    secret_name=$(
        kubectl -n "${namespace}" get secret -n "${namespace}" -o name
    )
    kubectl -n "${namespace}" describe "${secret_name}" | grep "token:"

}

install_docker_compose() {

    sudo curl -L \
        "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose \
        /usr/bin/docker-compose

}

install_docker_rhel() {

    sudo yum remove docker -y \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine

    sudo yum install -y yum-utils

    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install -y docker-ce docker-ce-cli containerd.io
}

install_docker() {

    install_docker_rhel
    sudo systemctl enable --now docker
    sudo usermod -aG docker "${USER}"
    install_docker_compose

}
