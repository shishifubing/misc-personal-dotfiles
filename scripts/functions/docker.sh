#!/bin/env bash

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
