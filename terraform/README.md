# Description

Personal terraform configs

---

# Architecture

TODO

---

# Usage

```bash
export PACKER_VARIABLES="" # define packer variables if you need to
make                       # build images, it is a wrapper for `packer build .`
terraform apply            # create infrastructure
```

---

# Setup

> **_NOTE:_** variables.pkr.hcl is a link to variables.tf to reuse terraform
> variables in packer builds

---

## Install terraform, install packer, install gitversion, link .terraformrc

```bash
#!/usr/bin/env bash
host="https://hashicorp-releases.yandexcloud.net"
github_url="https://github.com/GitTools/GitVersion/releases/download"

terraform_version="1.3.6"
packer_version="1.8.5"
gitversion_version="5.11.1"

terraform_distrib="terraform_${terraform_version}_linux_amd64.zip"
packer_distrib="packer_${packer_version}_linux_amd64.zip"
gitversion_distrib="gitversion-linux-x64-${gitversion_version}.tar.gz"

wget "${host}/terraform/${terraform_version}/${terraform_distrib}"
wget "${host}/packer/${packer_version}/${packer_distrib}"
wget "${github_url}/${gitversion_version}/${gitversion_distrib}"

unzip "${terraform_distrib}"
unzip "${packer_distrib}"
tar -xvzf "${gitversion_distrib}"
rm -rf "${terraform_distrib}" "${packer_distrib}" "${gitversion_distrib}"
chmod +x terraform packer gitversion
sudo mv terraform packer gitversion /usr/bin/

ln -fs "${HOME}/Dotfiles/terraform/.terraformrc" "${HOME}/.terraformrc"
```

---

## Delegate domain

In order for cloud DNS to work, you need to delegate your domain to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

## Custom github.io domain

Conifigure the domain in [networking.tf][networking] and
[add it to Github Pages][github-pages]

---

# Documentation

- [Yandex Cloud][yandex-cloud] documentation

- [Terraform provider][terraform] documentation

- [Packer builder][packer] documentation

- `*.cloud-init.yml` files - [cloud-init][cloud-init] configuration files

---

<!-- internal links -->

[networking]: ./yandex_cloud/networking.tf

<!-- external links -->

[github-pages]: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
[packer]: https://developer.hashicorp.com/packer/plugins/builders/yandex
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
[terraform]: https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs
[yandex-cloud]: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
