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
(application load balancer cannot be created if it's certificate for it is not valid)

---

# Setup

## Delegate domain

In order for public Cloud DNS to work with your domain, you need to delegate it to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

## Local environment

- terraform
- packer
- gitversion
- kubectl
- yc
- helm

```bash
# install tools, link .terraformrc, link .bashrc
# it is mainly a server setup script, so there might be side effects
./modules/yandex_cloud/packer/setup.sh
# build images and create infrastructure
make
# setup ssh
echo "$(terraform output -raw ssh_config)" >>"${HOME}/.ssh/config"
# setup local kubectl
./setup_kubectl.sh
```

---

# Documentation

- [Yandex Cloud][yandex-cloud] documentation

- [Terraform provider][terraform] documentation

- [Packer builder][packer] documentation

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
