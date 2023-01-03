# https://unix.stackexchange.com/questions/270778/how-to-write-exactly-bash-scripts-into-makefiles

define build =
PACKER_VARS="${PACKER_VARS:-}"
version=$(jq -r ".FullSemVer" <(gitversion))
version="${version//./-}"
echo "image version: ${version}"
echo -e "${PACKER_VARS}\nversion = \"${version}\"" \
	> "_variables.pkrvars.hcl"
packer build -var-file "_variables.pkrvars.hcl" .
terraform apply
endef

build: ; $(value build)

.ONESHELL: