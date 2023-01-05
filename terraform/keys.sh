#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID="YCAJEinXehd33OHzgQ_CZebrm"
key_path="${HOME}/Credentials/yc/terraform-state-manager-token.txt"
AWS_SECRET_ACCESS_KEY=$(<"${key_path}")
export AWS_SECRET_ACCESS_KEY