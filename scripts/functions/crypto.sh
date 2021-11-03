#!/usr/bin/env bash

### certificates
## create a certificate
crypto_certificate_create() {

    openssl req -newkey rsa:4096 -nodes -keyout "${1}.key" \
        -x509 -days 365 -out "${1}".crt

}

### openssl

## create a password
crypto_openssl_rand() {

    openssl rand -base64 "${1:-36}"

}
