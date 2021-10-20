#!/bin/env bash

### kubernetes

## get token, one line
kubernetes_token() {

    sudo kubectl -n "${namespace}" describe secret $( \
	sudo kubectl -n "${namespace}" get secret \
	    | (grep "${account_name}" || echo "$_") \
	    | awk '{print $1}' \
    ) | grep token: | awk '{print $2}'


}

## get token contents
kubernetes_token_() {
 
    kubectl get -n "${namespace}" secret "${token_name}" -o yaml
 
}

## get token name
kubernetes_token_name() {

    kubectl get -n "${namespace}" "${account_name}" -o yaml

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
	
    local namespace service
    
    namespace="${1}"
    service="${2}"

    export NODE_PORT=$(kubectl get --namespace "${namespace}" -o \
        jsonpath="{.spec.ports[0].nodePort}" services "${service}" \
    )
    export NODE_IP=$(kubectl get nodes --namespace production -o \
        jsonpath="{.items[0].status.addresses[0].address}"
    )
  echo http://$NODE_IP:$NODE_PORT


export NODE_PORT=$(kubectl get --namespace production -o jsonpath="{.spec.ports[0].nodePort}" services example-prod-sample-app)
  export NODE_IP=$(kubectl get nodes --namespace production -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT

}

kubernetes_get_token() {

    local namespace secret_name


    namespace="${1}"

    secret_name=$( \
        kubectl -n "${namespace}" get secret -n "${namespace}" -o name \
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
