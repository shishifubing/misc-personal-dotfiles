#!/usr/bin/env bash
set -euxo pipefail

yc managed-kubernetes cluster get-credentials \
    --internal                                \
    --name default
kubectl cluster-info