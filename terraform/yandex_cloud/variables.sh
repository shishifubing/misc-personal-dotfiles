#!/usr/bin/env bash

dir="${HOME}/Credentials/yc"

# second - secret key
# fist line in the file - key id
AWS_ACCESS_KEY_ID=$(sed -n 1p "${dir}/terraform-state-manager-token.txt")
AWS_SECRET_ACCESS_KEY=$(sed -n 2p "${dir}/terraform-state-manager-token.txt")

TF_authorized_key=$(<"${dir}/authorized_key.personal.json")
PKR_VAR_oauth_key=$(<"${dir}/oauth_key.txt")

export AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID TF_authorized_key \
    PKR_VAR_authorized_key PKR_VAR_oauth_key