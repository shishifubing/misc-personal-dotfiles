# https://unix.stackexchange.com/questions/270778/how-to-write-exactly-bash-scripts-into-makefiles

define build =
. ./variables.sh
cd packer
packer build .
endef

build: ; $(value build)

.ONESHELL: