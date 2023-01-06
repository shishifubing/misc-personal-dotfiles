#!/usr/bin/env bash
set -Eeuxo pipefail

PACKER_VARS="${PACKER_VARS:-}"
version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
echo "image version: ${version}"
cd packer
echo "
${PACKER_VARS}
version = \"${version}\"
" > "_variables.pkrvars.hcl"
packer build -var-file "_variables.pkrvars.hcl" .
cd ..