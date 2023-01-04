#!/usr/bin/env bash
set -euxo pipefail

PACKER_VARS="${PACKER_VARS:-}"
version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
echo "image version: ${version}"
cd yandex_cloud/packer
echo "
${PACKER_VARS}
version = \"${version}\"
" > "_variables.pkrvars.hcl"
packer build -var-file "_variables.pkrvars.hcl" .
cd ../../
terraform apply -target=module.yandex_cloud