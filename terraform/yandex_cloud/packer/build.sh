#!/usr/bin/env bash
set -Eeuxo pipefail

version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
packer build -var version="${version}" "${@}" .