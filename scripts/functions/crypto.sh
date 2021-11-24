#!/usr/bin/env bash

### certificates
## create a certificate
crypto_certificate_create() {

    local file_name domains

    file_name="${1}"
    shift
    read -ra domains <<<"${@}"
    domains_string="DNS.1:localhost"

    for ((i = 0; i < ${#}; i++)); do
        domains_string+=",DNS.$((i + 2)):${domains[${i}]}"
    done

    openssl req \
        -x509 \
        -newkey rsa:4096 \
        -sha256 \
        -days 3560 \
        -nodes \
        -keyout "${file_name}.key" \
        -out "${file_name}.crt" \
        -subj "/CN=${file_name}" \
        -extensions san \
        -config <(
            echo "[req]"
            echo "distinguished_name=req"
            echo "[san]"
            echo "subjectAltName=${domains_string}"
        )

}

### openssl

## create a password
crypto_openssl_rand() {

    openssl rand -base64 "${1:-36}"

}
