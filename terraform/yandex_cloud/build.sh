#!/usr/bin/env bash
set -euxo pipefail

PACKER_VARS="${PACKER_VARS:-}"
version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
echo "image version: ${version}"
echo -e "${PACKER_VARS}\nversion = \"${version}\"" > "_variables.pkrvars.hcl"
packer build -var-file "_variables.pkrvars.hcl" .
terraform apply