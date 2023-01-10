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
# build images
make
# update infrastructure
terraform apply
```

---

# Getting started

## Create a folder in the cloud

Create a folder, then modify [variables.tf][variables.tf] and
[packer/variables.pkr.hcl][packer-variables]

---

## Delegate domain

In order for public Cloud DNS to work with your domain, you need to delegate it to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

## Setup terraform backend and local environment

You need to:

- create an s3 bucket to store the terraform state file
- create `terraform-state-manager` service account with `storage.editor`
  role
  (without the role the account will not be able to work with the bucket no
  matter what)
- create a policy allowing that account to create, retrieve, and modify the
  state file in that bucket
- create a static key for that account, download it
- modify [variables.sh][variables.sh]
- change backend bucket configuration in [production.s3.tfbackend][backend]
  or use your own backend file
- initialize terraform backend (full command is below)

[S3 backend in Yandex Cloud][yandex-terraform-s3-backend] documentation

[S3 terraform backend][terraform-s3-backend] documentation

```bash
# install tools, link .terraformrc, link .bashrc
# it is mainly a server setup script, so there might be side effects
./packer/setup.sh
# export credentials
# they need to be exported when you run terraform commands
# you need to execute the script in your current shell (either . or source)
. ./variables.sh
# initialize terraform backend
terraform init -reconfigure -backend-config=./production.s3.tfbackend
# build images
make
# create the infrastructure
terraform apply -target=modules.main
# setup ssh
echo "$(terraform output -raw ssh_config)" >>"${HOME}/.ssh/config"
# setup local kubectl
./setup_kubectl.sh
# setup the cluster
terraform apply
```

[`setup.sh`][setup.sh] script installs:

- [`terraform`][terraform]
- [`packer`][packer]
- [`gitversion`][gitversion]
- [`kubectl`][kubectl]
- [`yc`][yc]
- [`helm`][helm]

---

### Helm provider fails to download helm charts and doesn't provide a reason

```
Error: could not download chart: failed to download
"oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress/chart"
```

Downloads of `oci://` charts fail if they are not specified properly,
they should be specified like so:

```hcl
version = "v0.1.9"
chart = "chart"
repository = "oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress"
```

---

# Documentation

- [Yandex Cloud][yandex-cloud] documentation
- [Yandex terraform provider][yandex-terraform] documentation
- [Packer builder][yandex-packer] documentation
- [Terraform backend in Yandex Cloud][yandex-terraform-s3-backend]
  documentation
- [S3 terraform backend][terraform-s3-backend] documentation
- `*.cloud-init.yml` files - [cloud-init][cloud-init] configuration files

---

<!-- internal links -->

[networking]: ./modules/main/networking.tf
[setup.sh]: ./packer/setup.sh
[backend]: ./main.s3.tfbackend
[variables.sh]: ./variables.sh
[variables.tf]: ./variables.tf
[packer-variables]: ./packer/variables.pkr.hcl

<!-- external links -->

[github-pages]: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
[yandex-terraform]: https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs
[yandex-packer]: https://developer.hashicorp.com/packer/plugins/builders/yandex
[yandex-cloud]: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
[yandex-terraform-s3-backend]: https://cloud.yandex.com/en-ru/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend
[terraform-s3-backend]: https://developer.hashicorp.com/terraform/language/settings/backends/s3
[terraform]: https://www.terraform.io/
[helm]: https://helm.sh/
[yc]: https://cloud.yandex.com/en/docs/cli/quickstart
[kubectl]: https://kubernetes.io/docs/reference/kubectl/
[packer]: https://developer.hashicorp.com/packer/docs/intro
[gitversion]: https://gitversion.net
