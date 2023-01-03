#!/usr/bin/env bash
set -euxo pipefail

yc init
yc managed-kubernetes cluster \
  get-credentials "$(terraform output -raw )" \
  --internal