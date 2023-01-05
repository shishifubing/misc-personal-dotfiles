#!/usr/bin/env bash
set -Eeuxo pipefail

PACKER_VARS="${PACKER_VARS:-}"
version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
echo "image version: ${version}"
cd modules/yandex_cloud/packer
echo "
${PACKER_VARS}
version = \"${version}\"
" > "_variables.pkrvars.hcl"
packer build -var-file "_variables.pkrvars.hcl" .
cd ../../../
terraform apply -auto-approve