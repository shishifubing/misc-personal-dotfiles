# https://unix.stackexchange.com/questions/270778/how-to-write-exactly-bash-scripts-into-makefiles

define build =
version=$(jq -r '.FullSemVer' <(gitversion))
echo "image version: ${version}"
packer build -var image_version="${version}" .
endef

build: ; $(value build)

.ONESHELL: