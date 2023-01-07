#!/usr/bin/env bash
set -Eeuxo pipefail

# you have to pass a script to expect
yc init                           \
    --folder-id "${YC_FOLDER_ID}" \
    --cloud-id "${YC_CLOUD_ID}"