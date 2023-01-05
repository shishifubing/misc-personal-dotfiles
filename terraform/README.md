# Description

Personal terraform configs

---

# Architecture

TODO

---

# Usage

```bash
# define packer variables if you need to
export PACKER_VARIABLES=""
# build images and update infrastructure
make
# or just update infrastructure
terraform apply
```

First `terraform apply` might take dozens of minutes because of certificate validation and cluster creation

---

# Setup

## Delegate domain

In order for public Cloud DNS to work with your domain, you need to delegate it to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

## Setup terraform backend and local environment

You need to:

- create a bucket to store the terraform state file
- create an account which is able to create, retrieve and modify it
- create a static key
- initialize terraform backend with `terraform init`

[Terraform backend in Yandex Cloud][bucket-terraform-state] documentation
[S3 terraform backend][terraform-s3-backend] documentation

> **_NOTE:_** first `terraform apply` will fail because you need to setup
> kubectl first by running `./setup_kubectl.sh`

```bash
# install tools, link .terraformrc, link .bashrc
# it is mainly a server setup script, so there might be side effects
./modules/yandex_cloud/packer/setup.sh
# export AWS credentials
# they need to be exported when you run terraform commands
# you need to execute the script in your current shell (either . or source)
. ./keys.sh
# initialize terraform backend
terraform init -reconfigure
# build images and create infrastructure
make
# setup ssh
echo "$(terraform output -raw ssh_config)" >>"${HOME}/.ssh/config"
# setup local kubectl
./setup_kubectl.sh
```

[`setup.sh`][setup.sh] script installs:

- `terraform`
- `packer`
- `gitversion`
- `kubectl`
- `yc`
- `helm`

---

# Documentation

- [Yandex Cloud][yandex-cloud] documentation
- [Terraform provider][terraform] documentation
- [Packer builder][packer] documentation
- [Terraform backend in Yandex Cloud][bucket-terraform-state] documentation
- [S3 terraform backend][terraform-s3-backend] documentation
- `*.cloud-init.yml` files - [cloud-init][cloud-init] configuration files

---

<!-- internal links -->

[networking]: ./modules/yandex_cloud/networking.tf

<!-- external links -->

[github-pages]: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
[packer]: https://developer.hashicorp.com/packer/plugins/builders/yandex
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
[terraform]: https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs
[yandex-cloud]: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
[bucket-terraform-state]: https://cloud.yandex.com/en-ru/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend
[terraform-s3-backend]: https://developer.hashicorp.com/terraform/language/settings/backends/s3
[setup.sh]: ./modules/yandex_cloud/packer/setup.sh
